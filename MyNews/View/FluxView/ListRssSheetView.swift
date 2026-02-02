//
//  ListRssSheetView.swift
//  MyNews
//
//  Created by Sebby on 10/05/2024.
//

import SwiftUI

struct ListRssSheetView: View {
    @ObservedObject var linkManager: LinkManager
    @Binding var showSheetView: Bool
    @FocusState private var isFocused: Bool
    @State private var okButtonOpacity: Double = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    // --- INPUT CARD ---
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Nouvelle Source")
                            .font(.caption).bold()
                            .foregroundColor(.secondary)
                            .padding(.leading, 5)
                        
                        HStack {
                            TextField("URL du flux RSS", text: $linkManager.linkTapped)
                                .focused($isFocused)
                                .onAppear { linkManager.getClipboardContent() }
                            
                            Button {
                                withAnimation(.spring()) { linkManager.addLink() }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(linkManager.linkTapped.isEmpty ? .gray : .blue)
                            }
                            .disabled(linkManager.linkTapped.isEmpty)
                        }
                        .padding()
                        .background(Color.primary.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal)

                    // --- SECTIONS DE STATUT ---
                    // On appelle ici tes sections filtrées (Vérifié, En attente, etc.)
                    // Elles utilisent le composant RSSListSection refondu
                    VStack(spacing: 20) {
                        RSSListSection(linkManager: linkManager, header: "Vérifiés", status: .checked)
                        RSSListSection(linkManager: linkManager, header: "En attente", status: .pending)
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationTitle("Gérer les liens")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Terminer") { showSheetView.toggle() }.bold()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ListRssSheetView(linkManager: LinkManager(), showSheetView: .constant(true))
    }
}

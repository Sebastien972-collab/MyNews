//
//  FluxView.swift
//  MyNews
//
//  Created by Sebby on 20/04/2024.
//

import SwiftUI

struct FluxView: View {
    @StateObject private var fluxManager = FluxViewManager()
    @State private var showSheetView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fond liquide dynamique
                LinearGradient(colors: [.orange.opacity(0.1), .purple.opacity(0.1), .white],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                if fluxManager.inProgress {
                    // Loader en verre
                    VStack(spacing: 15) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Mise à jour...")
                            .font(.caption).bold()
                            .foregroundColor(.secondary)
                    }
                    .padding(30)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                } else if fluxManager.items.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "antenna.radiowaves.left.and.right")
                            .font(.system(size: 50))
                            .foregroundStyle(.tertiary)
                        Text("Aucun flux détecté")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 16) {
                            ForEach(fluxManager.items) { item in
                                NavigationLink(destination: SafariView(url: item.link)) {
                                    RssRow(rssItem: item)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.top)
                    }
                    .refreshable { fluxManager.refresh() }
                }
            }
            .navigationTitle("Abonnements")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showSheetView.toggle() } label: {
                        Image(systemName: "plus.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showSheetView) {
                ListRssSheetView(linkManager: fluxManager.linkManager, showSheetView: $showSheetView)
                    .presentationDetents([.medium, .large])
                    .presentationBackground(.ultraThinMaterial) // La sheet est aussi en verre !
            }
            .onAppear(){
                if !fluxManager.linkManager.fluxLinks.isEmpty && fluxManager.items.isEmpty {
                    fluxManager.refresh()
                }
            }
        }
    }
}

#Preview {
    FluxView()
}

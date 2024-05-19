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
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField("Ajoutez un lien ", text: $linkManager.linkTapped)
                            .onAppear {
                                linkManager.getClipboardContent()
                            }
                        Button {
                            withAnimation {
                                linkManager.addLink()
                            }
                            print("Button pressed")
                            
                        } label: {
                            Text("Add")
                                .bold()
                                .foregroundStyle(linkManager.linkTapped.isEmpty ? .gray : .blue)
                                .animation(.easeInOut(duration: 2), value: linkManager.linkTapped)
                        }
                    }
                }
                
                RSSListSection(linkManager: linkManager, header: "Vérifier", status: .checked)
                RSSListSection(linkManager: linkManager, header: "En attente", status: .pending)
                RSSListSection(linkManager: linkManager, header: "Lien érroné", status: .bad)
                RSSListSection(linkManager: linkManager, header: "Non Approuvé", status: .unapproved)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showSheetView.toggle()
                    }, label: {
                        Text("Done")
                    })
                }
            }
            .alert(linkManager.linkError.localizedDescription, isPresented: $linkManager.showLinkError) {
                Button("Ok", role: .cancel) { }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ListRssSheetView(linkManager: LinkManager(), showSheetView: .constant(true))
    }
}

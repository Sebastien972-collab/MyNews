//
//  ListRssSheetView.swift
//  MyNews
//
//  Created by Sebby on 10/05/2024.
//

import SwiftUI

struct ListRssSheetView: View {
    @ObservedObject var fluxManager: FluxViewManager
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField("Ajoutez un lien ", text: $fluxManager.linkTapped)
                        Button {
                            fluxManager.addLink()
                        } label: {
                            Text("Add")
                        }

                    }
                }
                
                RSSListSection(fluxManager: fluxManager, header: "Vérifier", status: .checked)
                RSSListSection(fluxManager: fluxManager, header: "En attente", status: .pending)
                RSSListSection(fluxManager: fluxManager, header: "Lien érroné", status: .bad)
                RSSListSection(fluxManager: fluxManager, header: "Non Approuvé", status: .unapproved)
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        fluxManager.listBeingModified.toggle()
                    }, label: {
                        Text("Done")
                    })
                }
            }
            .alert(fluxManager.linkError.localizedDescription, isPresented: $fluxManager.showError) {
                Button("Ok", role: .cancel) { }
        }
        }
    }
}

#Preview {
    NavigationStack {
        ListRssSheetView(fluxManager: FluxViewManager())
    }
}

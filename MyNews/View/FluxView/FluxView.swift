//
//  FluxView.swift
//  MyNews
//
//  Created by Sebby on 20/04/2024.
//

import SwiftUI

struct FluxView: View {
    @StateObject var fluxManager = FluxViewManager()
    @State var showSheetView: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                if fluxManager.items.isEmpty {
                    Text("Aucun flux détecté")
                }
                ZStack(content: {
                    if fluxManager.inProgress {
                        ProgressView()
                    } else {
                        ScrollView {
                            VStack {
                                ForEach(fluxManager.items) { item in
                                    NavigationLink {
                                        SafariView(url: item.link)
                                    } label: {
                                        RssRow(rssItem: item)
                                    }
                                }
                            }
                            .navigationTitle(Text("Flux"))
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar(content: {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button(action: {
                                        showSheetView.toggle()
                                    }, label: {
                                        Image(systemName: "plus.circle")
                                    })
                                }
                            })
                        }
                        .refreshable {
                            fluxManager.refresh()
                        }
                    }
                })
                .alert(fluxManager.error.localizedDescription, isPresented: $fluxManager.showError) {
                    Button("Ok", role: .cancel) { }
                }
            }
        }
        .sheet(isPresented: $showSheetView, content: {
            ListRssSheetView(linkManager: fluxManager.linkManager, showSheetView: $showSheetView)
        })
        .onAppear(){
            
            if !fluxManager.linkManager.fluxLinks.isEmpty && fluxManager.items.isEmpty {
                fluxManager.refresh()
            }
        }
    }
}

#Preview {
    FluxView()
}

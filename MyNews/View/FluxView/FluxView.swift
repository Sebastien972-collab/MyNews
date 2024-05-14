//
//  FluxView.swift
//  MyNews
//
//  Created by Sebby on 20/04/2024.
//

import SwiftUI

struct FluxView: View {
    @StateObject var fluxManager = FluxViewManager()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Picker("What flux do you see", selection: $fluxManager.segmentedControl) {
                        ForEach(FluxViewManager.SegmentedCommand.allCases) { item in
                            Text(item.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
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
                .sheet(isPresented: $fluxManager.listBeingModified, content: {
                    ListRssSheetView(fluxManager: fluxManager)
                }) 
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            fluxManager.listBeingModified.toggle()
                        }, label: {
                            Image(systemName: "plus.circle")
                        })
                    }
                })
            }
            .alert(fluxManager.rssError.localizedDescription, isPresented: $fluxManager.showError) {
                Button("Ok", role: .cancel) { }
            }
        }
        
        .onAppear(){
            fluxManager.fetchRss()
        }
    }
}

#Preview {
    FluxView()
}

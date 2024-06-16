//
//  SettingsView.swift
//  MyNews
//
//  Created by Sebby on 16/06/2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section {
                NavigationLink {
                    ConnectionView(selection: .signIn)
                } label: {
                    Label("Se connecter", systemImage: "person.fill")
                }
                NavigationLink {
                    ConnectionView(selection: .signUp)
                } label: {
                    Label("Créer un compte ", systemImage: "person.fill.badge.plus")
                }
            } header: {
                Text("Compte")
            }
            Section {
                NavigationLink {
                    BookMarkView()
                } label: {
                    Label("Bookmark", systemImage: "bookmark.fill")
                }
                NavigationLink {
                    Text("Aboonements Settings")
                } label: {
                    Label("Abonnements", systemImage: "checkmark.rectangle.stack.fill")
                }
            } header: {
                Text("Abonnements")
            }
            Section {
                NavigationLink {
                    Text("Notifications settings")
                } label: {
                    Label("Notifications", systemImage: "bell.badge.circle.fill")
                }

                NavigationLink {
                    Text("Apparences settings")
                } label: {
                    Label("Apparence", systemImage: "moonset.circle.fill")
                }

            } header: {
                Text("Réglages")
            }
            Section {
                NavigationLink {
                    SafariView(url: "https://mon-site-pro-9fced.web.app/")
                } label: {
                    Label("Site du développeur", systemImage: "macbook.and.iphone")
                }

            } header: {
                Text("À propos ")
            }
        }
        .navigationTitle(Text("Réglages"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}

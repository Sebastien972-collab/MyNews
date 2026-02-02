//
//  SettingsView.swift
//  MyNews
//
//  Created by Sebby on 16/06/2024.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var loginManager: LoginViewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            // Rappel du fond "Liquid" pour la cohérence
            LinearGradient(colors: [.blue.opacity(0.15), .purple.opacity(0.1), .white],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    
                    // --- PROFILE SECTION ---
                    VStack {
                        if loginManager.isAuth() {
                            HStack(spacing: 15) {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.blue)
                                
                                VStack(alignment: .leading) {
                                    Text("Sébastien D.")
                                        .font(.headline)
                                    Text("Compte Premium")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding()
                        } else {
                            HStack {
                                settingsLink(icon: "person.badge.key.fill", title: "Se connecter", destination: ConnectionView(selection: .signIn))
                                Divider().frame(height: 20)
                                settingsLink(icon: "person.fill.badge.plus", title: "S'inscrire", destination: ConnectionView(selection: .signUp))
                            }
                            .padding()
                        }
                    }
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.4), lineWidth: 1))
                    
                    // --- GROUPED SECTIONS ---
                    VStack(spacing: 1) { // L'espace de 1 crée une fine ligne entre les rangées
                        settingRow(icon: "bookmark.fill", title: "Signets", color: .orange, destination: BookMarkView())
                        Divider().padding(.leading, 50)
                        settingRow(icon: "checkmark.rectangle.stack.fill", title: "Abonnements", color: .green, destination: Text("Abonnements Settings"))
                    }
                    .glassGroup()

                    VStack(spacing: 1) {
                        settingRow(icon: "bell.badge.fill", title: "Notifications", color: .red, destination: Text("Notifications settings"))
                        Divider().padding(.leading, 50)
                        settingRow(icon: "moon.stars.fill", title: "Apparence", color: .purple, destination: ApparenceView())
                    }
                    .glassGroup()
                    
                    VStack(spacing: 1) {
                        settingRow(icon: "safari.fill", title: "Site du développeur", color: .blue, destination: SafariView(url: "https://mon-site-pro-9fced.web.app/"))
                    }
                    .glassGroup()
                    
                    Text("MyNews v2.0 - 2026")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.top)
                }
                .padding()
            }
        }
        .navigationTitle("Réglages")
    }
    
    // Helper pour une ligne de réglage propre
    @ViewBuilder
    func settingRow<V: View>(icon: String, title: String, color: Color, destination: V) -> some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(color.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.secondary.opacity(0.5))
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
        }
    }

    // Helper pour les liens simples
    @ViewBuilder
    func settingsLink<V: View>(icon: String, title: String, destination: V) -> some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption).bold()
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// Extension pour styliser les groupes de réglages en une fois
extension View {
    func glassGroup() -> some View {
        self
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.4), lineWidth: 1))
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}

//
//  ApparenceView.swift
//  MyNews
//
//  Created by Sebby on 15/10/2024.
//

import SwiftUI


struct ApparenceView: View {
    @StateObject var manager = ApparenceManager()
    
    var body: some View {
        ZStack {
            // Fond dynamique pour voir l'effet de transparence en temps réel
            LinearGradient(colors: [.purple.opacity(0.15), .blue.opacity(0.1), .white],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                VStack(spacing: 8) {
                    Text("Apparence")
                        .font(.system(.largeTitle, design: .rounded))
                        .bold()
                    Text("Choisissez comment MyNews s'affiche pour vous.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)

                // Sélecteur visuel sous forme de cartes
                HStack(spacing: 15) {
                    ForEach(AppAppearance.allCases, id: \.self) { mode in
                        AppearanceCard(mode: mode, isSelected: manager.appearance == mode) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                manager.appearance = mode
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Un petit rappel sur le mode automatique
                if manager.appearance == .automatic {
                    Text("MyNews s'adaptera automatiquement aux réglages de votre système.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

// Composant de carte visuelle
struct AppearanceCard: View {
    let mode: AppAppearance
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                // Aperçu visuel du mode
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 4).fill(previewColor(for: mode)).frame(height: 10)
                    RoundedRectangle(cornerRadius: 4).fill(previewColor(for: mode).opacity(0.5)).frame(height: 6)
                    RoundedRectangle(cornerRadius: 4).fill(previewColor(for: mode).opacity(0.3)).frame(width: 40, height: 6)
                }
                .padding(12)
                .frame(width: 80, height: 100)
                .background(mode == .dark ? Color.black : Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                )
                
                Text(mode.rawValue)
                    .font(.caption).bold()
                    .foregroundColor(isSelected ? .primary : .secondary)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(isSelected ? Color.blue.opacity(0.5) : Color.white.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(.plain)
    }
    
    private func previewColor(for mode: AppAppearance) -> Color {
        mode == .dark ? .white : .black
    }
}
#Preview {
    ApparenceView()
}

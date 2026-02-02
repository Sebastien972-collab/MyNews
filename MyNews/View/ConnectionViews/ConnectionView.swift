//
//  ConnectionView.swift
//  MyNews
//
//  Created by Sebby on 29/03/2024.
//

import SwiftUI
import _AuthenticationServices_SwiftUI
import GoogleSignInSwift

struct ConnectionView: View {
    var selection: LoginViewModel.TypeOfConnectionSelection
    @StateObject var loginManger: LoginViewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            // Fond liquide (Blue/Purple/White)
            LinearGradient(colors: [.blue.opacity(0.1), .purple.opacity(0.1), .white],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // --- HEADER ---
                VStack(spacing: 15) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.blue)
                        .background(Circle().fill(.ultraThinMaterial))
                    
                    Text("Pour profiter de toutes les fonctionnalités à venir")
                        .font(.system(.subheadline, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 40)
                
                // --- FORMULAIRE ---
                VStack(spacing: 1) {
                    CustomTextField(hint: "Email", text: $loginManger.email, contentype: .emailAddress)
                        .padding()
                        .background(.ultraThinMaterial.opacity(0.5))
                    
                    Divider().padding(.leading)
                    
                    CustomTextField(isSecureField: true, hint: "Password", text: $loginManger.password, contentype: .password)
                        .padding()
                        .background(.ultraThinMaterial.opacity(0.5))
                }
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(.white.opacity(0.3), lineWidth: 1))
                .padding(.horizontal)
                
                // --- BOUTON PRINCIPAL ---
                Button(action: {
                    // Logique de connexion
                }) {
                    Text(selection.rawValue)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.gradient)
                        .clipShape(Capsule())
                        .shadow(color: .blue.opacity(0.3), radius: 10, y: 5)
                }
                .padding(.horizontal)
                
                // --- AUTH TIERS ---
                VStack(spacing: 20) {
                    HStack {
                        Rectangle().fill(Color.secondary.opacity(0.2)).frame(height: 1)
                        Text("OU").font(.caption2).bold().foregroundColor(.secondary)
                        Rectangle().fill(Color.secondary.opacity(0.2)).frame(height: 1)
                    }
                    .padding(.horizontal, 40)
                    
                    VStack(spacing: 12) {
                        SignInWithAppleButton(selection == .signIn ? .signIn : .signUp,
                            onRequest: { _ in },
                            onCompletion: { _ in }
                        )
                        .signInWithAppleButtonStyle(.black)
                        .frame(height: 50)
                        .clipShape(Capsule())
                        
                        GoogleSignInButton {
                            // Action Google
                        }
                        .frame(height: 50)
                        .clipShape(Capsule())
                    }
                    .frame(maxWidth: 280)
                }
                
                Spacer()
            }
        }
        .navigationTitle(selection.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ConnectionView(selection: .signIn)
    }
}

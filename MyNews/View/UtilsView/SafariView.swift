//
//  SafariView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 22/03/2023.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: String

    func makeUIViewController(context: Context) -> SFSafariViewController {
        // Validation de l'URL pour éviter le crash au cas où elle serait mal formée
        guard let url = URL(string: self.url) else {
            // URL de secours ou gestion d'erreur
            return SFSafariViewController(url: URL(string: "https://google.com")!)
        }
        
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = true // UX : Ouvre directement en mode lecture si possible
        
        let safariVC = SFSafariViewController(url: url, configuration: configuration)
        
        // Personnalisation Liquid Glass : on adapte les couleurs de l'interface Safari
        safariVC.preferredControlTintColor = .systemBlue
        safariVC.dismissButtonStyle = .close
        
        return safariVC
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Pas de mise à jour nécessaire pour Safari
    }
}

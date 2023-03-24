//
//  SafariView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 22/03/2023.
//

import SwiftUI
import SafariServices

struct SafariView : UIViewControllerRepresentable {
    let url : String
    typealias UIViewControllerType = SFSafariViewController
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let controller = SFSafariViewController(url: URL(string: url)!)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
}

//
//  SafariView.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 22/03/2023.
//

import SwiftUI
import SafariServices
import WebKit
struct SafariView : UIViewControllerRepresentable {
    let url: String
        
        func makeUIViewController(context: Context) -> UIViewController {
            let viewController = UIViewController()
            let webView = WKWebView(frame: viewController.view.frame, configuration: configureWebView())
            viewController.view.addSubview(webView)
            webView.load(URLRequest(url: URL(string: url)!))
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            if let webView = uiViewController.view.subviews.first as? WKWebView {
                webView.load(URLRequest(url: URL(string: url)!))
            }
        }
        
        private func configureWebView() -> WKWebViewConfiguration {
            let configuration = WKWebViewConfiguration()
            configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
            return configuration
        }
}

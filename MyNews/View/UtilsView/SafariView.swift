import SwiftUI
import SafariServices

struct SafariView: View {
    let url: String

    var body: some View {
        if let destination = URL(string: url), destination.host != nil,
           ["https", "http"].contains(destination.scheme?.lowercased() ?? "") {
            ArticleBrowser(url: destination)
        } else {
            ContentUnavailableView("Lien indisponible", systemImage: "link",
                                   description: Text("L’adresse de cet article est invalide."))
        }
    }
}

private struct ArticleBrowser: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = true
        return SFSafariViewController(url: url, configuration: configuration)
    }

    func updateUIViewController(_ controller: SFSafariViewController, context: Context) { }
}

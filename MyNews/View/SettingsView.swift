import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var fluxManager: FluxViewManager
    @State private var showSources = false

    var body: some View {
        Form {
            Section("Lecture") {
                NavigationLink("Favoris") { BookMarkView() }
                Button("Gérer les sources RSS") { showSources = true }
                NavigationLink("Apparence") { ApparenceView() }
            }
            Section("À propos") {
                Link("Site du développeur", destination: URL(string: "https://mon-site-pro-9fced.web.app/")!)
                LabeledContent("Version", value: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "—")
                Text("Vos sources et favoris sont enregistrés sur cet appareil. Les articles s’ouvrent sur le site de leur éditeur.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Réglages")
        .sheet(isPresented: $showSources, onDismiss: { fluxManager.refresh() }) {
            ListRssSheetView(linkManager: fluxManager.linkManager, showSheetView: $showSources)
        }
    }
}

extension View {
    func glassGroup() -> some View {
        background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

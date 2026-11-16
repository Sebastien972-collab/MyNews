import SwiftUI

struct FluxView: View {
    @EnvironmentObject private var fluxManager: FluxViewManager
    @State private var showSources = false
    @State private var query = ""
    var title = "Abonnements"
    var showsSettings = false
    var allowsSearch = false

    private var filteredItems: [RSSItem] {
        let text = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return fluxManager.items }
        return fluxManager.items.filter {
            $0.title.localizedCaseInsensitiveContains(text)
                || $0.descriptionDecode.localizedCaseInsensitiveContains(text)
                || $0.hostname.localizedCaseInsensitiveContains(text)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if allowsSearch {
                    articleList.searchable(text: $query, prompt: "Dans les articles de vos sources")
                } else {
                    articleList
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Gérer les sources", systemImage: "plus.circle") { showSources = true }
                    if showsSettings {
                        NavigationLink { SettingsView() } label: {
                            Label("Réglages", systemImage: "gearshape")
                        }
                    }
                }
            }
            .sheet(isPresented: $showSources, onDismiss: { fluxManager.refresh() }) {
                ListRssSheetView(linkManager: fluxManager.linkManager, showSheetView: $showSources)
            }
            .alert("Mise à jour des flux", isPresented: $fluxManager.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(fluxManager.error.localizedDescription)
            }
            .onAppear { fluxManager.refresh() }
        }
    }

    private var articleList: some View {
        List {
            if fluxManager.inProgress {
                ProgressView("Mise à jour des sources…")
            }
            if filteredItems.isEmpty && !fluxManager.inProgress {
                ContentUnavailableView {
                    Label(query.isEmpty ? "Vos actualités" : "Aucun résultat", systemImage: "newspaper")
                } description: {
                    Text(query.isEmpty ? "Ajoutez vos sources RSS pour retrouver leurs articles ici." : "Essayez un autre mot dans les articles téléchargés de vos sources.")
                } actions: {
                    Button("Gérer mes sources") { showSources = true }
                    Button("Actualiser") { fluxManager.refresh() }
                }
            }
            ForEach(filteredItems) { item in
                NavigationLink {
                    NewsDetailView(article: item.article)
                } label: {
                    RssRow(rssItem: item)
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .refreshable { await fluxManager.refreshAndWait() }
    }
}

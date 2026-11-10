//
//  FluxViewManager.swift
//  MyNews
//
//  Created by Sébastien DAGUIN
//

import Foundation

class FluxViewManager: ObservableObject {
    @Published var items: [RSSItem] = []
    @Published var inProgress = false
    @Published var error: Error = RSSError.uknowError
    @Published var showError = false
    @Published var linkManager: LinkManager

    private let fetcher: RSSFetching
    private let store: RSSItemStoring

    init(fetcher: RSSFetching = RSSFetcher(), store: RSSItemStoring = RSSItemStore(),
         linkManager: LinkManager = LinkManager()) {
        self.fetcher = fetcher
        self.store = store
        self.linkManager = linkManager
        do {
            items = try store.load().filter { item in
                linkManager.fluxLinks.contains { $0.link == item.sourceURL }
            }
        } catch {
            self.error = error
            showError = true
        }
    }

    func fetchRss() {
        guard !inProgress else { return }
        let links = linkManager.fluxLinks
        let activeSources = Set(links.map(\.link))
        items.removeAll { !activeSources.contains($0.sourceURL ?? "") }
        guard !links.isEmpty else {
            do { try store.save([]) } catch { report(error) }
            return
        }
        inProgress = true
        showError = false
        fetcher.fetchRSS(links: links) { [weak self] checked, fetched in
            // Injectable fetchers may deliver on a background queue.
            DispatchQueue.main.async {
                guard let self else { return }
                defer { self.inProgress = false }
                let currentSources = Set(self.linkManager.fluxLinks.map(\.link))
                self.items.removeAll { !currentSources.contains($0.sourceURL ?? "") }
                if currentSources != activeSources {
                    self.inProgress = false
                    DispatchQueue.main.async { self.fetchRss() }
                    return
                }
                do {
                    try self.linkManager.favorLinksManager.updateStatuses(checked)
                    self.linkManager.refresh()
                } catch { self.report(error) }
                if let fetched {
                    let failed = Set(checked.filter { $0.status == .bad }.map(\.link))
                    let retained = self.items.filter { failed.contains($0.sourceURL ?? "") }
                    self.items = RSSItem.sortedUnique(fetched + retained).filter {
                        currentSources.contains($0.sourceURL ?? "")
                    }
                }
                if checked.contains(where: { $0.status == .bad }) { self.report(RSSError.unavailableSources) }
                do { try self.store.save(self.items) } catch { self.report(error) }
            }
        }
    }

    func refresh() {
        fetchRss()
    }

    private func report(_ error: Error) {
        self.error = error
        showError = true
    }
}

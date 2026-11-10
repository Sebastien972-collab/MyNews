//
//  RSSFoundationTests.swift
//  MyNewsTests
//
//  Created by Sébastien DAGUIN
//

import XCTest
import Alamofire
@testable import MyNews

final class RSSFoundationTests: XCTestCase {
    private let feed = "https://example.com/feed"

    func testParserHandlesCDATAFragmentsAndAtom() throws {
        let rss = """
        <rss><channel><item><title>A &amp; B</title><link>https://example.com/a</link>
        <description><![CDATA[<p>Résumé</p>]]></description>
        <pubDate>Tue, 14 May 2024 14:55:34 +0000</pubDate></item></channel></rss>
        """
        let item = try XCTUnwrap(RSSParserDelegate.parse(Data(rss.utf8))?.first)
        XCTAssertEqual(item.title, "A & B")
        XCTAssertEqual(item.description, "<p>Résumé</p>")
        XCTAssertNotNil(item.publishedDate)
        let atom = """
        <feed xmlns="http://www.w3.org/2005/Atom"><entry><title>Atom</title>
        <link rel="self" href="https://example.com/self"/>
        <link rel="alternate" href="https://example.com/atom"/>
        <summary>First <b>nested</b> text</summary><updated>2024-05-15T10:00:00Z</updated>
        </entry></feed>
        """
        let entry = try XCTUnwrap(RSSParserDelegate.parse(Data(atom.utf8))?.first)
        XCTAssertEqual(entry.link, "https://example.com/atom")
        XCTAssertEqual(entry.description, "First nested text")
        XCTAssertNotNil(entry.publishedDate)
    }

    func testMalformedAndNonFeedXMLAreRejected() {
        for xml in ["<rss><channel><item>", "<html><body>error</body></html>"] {
            XCTAssertNil(RSSParserDelegate.parse(Data(xml.utf8)))
        }
        XCTAssertEqual(RSSParserDelegate.parse(Data("<rss><channel/></rss>".utf8)), [])
        let invalidLink = "<rss><channel><item><link>javascript:alert(1)</link></item></channel></rss>"
        XCTAssertEqual(RSSParserDelegate.parse(Data(invalidLink.utf8)), [])
    }

    func testIdentityDeduplicationAndChronologicalSort() {
        let older = RSSItem(title: "Same title", link: "https://example.com/a", description: "", pubDate: "Tue, 14 May 2024 14:55:34 +0000")
        let newer = RSSItem(title: "Same title", link: "https://example.com/b", description: "", pubDate: "2024-05-15T10:00:00.000Z")
        let unknown = RSSItem(title: "Unknown", link: "https://example.com/c", description: "", pubDate: "invalid")
        XCTAssertEqual(RSSItem.sortedUnique([older, newer, older, unknown]), [newer, older, unknown])
        XCTAssertNotEqual(older.id, newer.id)
        XCTAssertFalse(older.calculateTimeDifference(from: "Tue, 14 May 2024 14:55:34 +0000").contains("minutes"))
        XCTAssertEqual(Set([Link(link: feed, status: .bad), Link(link: feed, status: .checked)]).count, 1)
    }

    func testCacheSurvivesReopeningAndDetectsCorruption() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appendingPathComponent("cache.json")
        let store = RSSItemStore(url: url)
        XCTAssertEqual(try store.load(), [])
        var item = RSSItem.preview
        item.sourceURL = feed
        try store.save([item, item])
        XCTAssertEqual(try RSSItemStore(url: url).load(), [item])
        try Data("invalid".utf8).write(to: url)
        XCTAssertThrowsError(try store.load())
    }

    func testSourceStatusAndDeletionUseURLIdentity() throws {
        let controller = PersistenceController(inMemory: true)
        let repository = FavoriteLinks(persistenceController: controller)
        try repository.saveArticle(link: Link(link: feed, status: .checked))
        let second = "https://example.com/second"
        try repository.saveArticle(link: Link(link: second))
        XCTAssertEqual(FavoriteLinks(persistenceController: controller).all.first?.status, .checked)
        try repository.updateStatuses([Link(link: feed, status: .bad)])
        XCTAssertEqual(repository.all.first?.status, .bad)
        let manager = LinkManager(favorLinksManager: repository)
        manager.fluxLinks.reverse()
        manager.removeLink(IndexSet(integer: 0))
        XCTAssertEqual(repository.all.map(\.link), [feed])
        manager.linkTapped = "file:///tmp/feed"
        manager.addLink()
        XCTAssertTrue(manager.showLinkError)
        XCTAssertEqual(repository.all.count, 1)
    }

    func testFavoriteDescriptionRoundTrip() throws {
        let repository = FavoriteNews(persistenceController: PersistenceController(inMemory: true))
        try repository.saveArticle(article: .preview)
        XCTAssertEqual(repository.all.first?.description, Article.preview.description)
    }

    func testFetcherCompletesOnceWithPartialFailureOnMainQueue() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [FeedURLProtocol.self]
        let session = Session(configuration: config)
        let fetcher = RSSFetcher(session: session)
        let done = expectation(description: "one aggregate callback")
        done.assertForOverFulfill = true
        fetcher.fetchRSS(links: [Link(link: "https://example.com/good"), Link(link: "https://example.com/http-error"), Link(link: "https://example.com/malformed")]) { links, items in
            XCTAssertTrue(Thread.isMainThread)
            XCTAssertEqual(links.map(\.status), [.checked, .bad, .bad])
            XCTAssertEqual(items?.count, 1)
            XCTAssertEqual(items?.first?.sourceURL, "https://example.com/good")
            done.fulfill()
        }
        wait(for: [done], timeout: 5)
    }

    func testFetcherHandlesEmptyAndTotalFailure() {
        let done = expectation(description: "empty and failed requests")
        done.expectedFulfillmentCount = 2
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [FeedURLProtocol.self]
        let fetcher = RSSFetcher(session: Session(configuration: config))
        fetcher.fetchRSS(links: []) { links, items in
            XCTAssertTrue(links.isEmpty)
            XCTAssertEqual(items, [])
            done.fulfill()
        }
        fetcher.fetchRSS(links: [Link(link: "https://example.com/offline"), Link(link: "file:///tmp/rss")]) { links, items in
            XCTAssertEqual(links.map(\.status), [.bad, .bad])
            XCTAssertNil(items)
            done.fulfill()
        }
        wait(for: [done], timeout: 5)
    }

    func testTotalFailureRetainsCacheAndEmptySuccessClearsIt() throws {
        let repository = FavoriteLinks(persistenceController: PersistenceController(inMemory: true))
        try repository.saveArticle(link: Link(link: feed))
        let fetcher = DeferredRSSFetcher()
        let cache = MemoryRSSStore()
        var old = RSSItem.preview
        old.sourceURL = feed
        cache.items = [old]
        let manager = FluxViewManager(fetcher: fetcher, store: cache,
                                      linkManager: LinkManager(favorLinksManager: repository))
        let source = feed
        let done = expectation(description: "offline retention then empty feed")
        manager.refresh()
        fetcher.completion?([Link(link: source, status: .bad)], nil)
        DispatchQueue.main.async {
            XCTAssertEqual(manager.items, [old])
            XCTAssertEqual(cache.items, [old])
            XCTAssertFalse(manager.inProgress)
            manager.refresh()
            fetcher.completion?([Link(link: source, status: .checked)], [])
            DispatchQueue.main.async {
                XCTAssertTrue(manager.items.isEmpty)
                XCTAssertTrue(cache.items.isEmpty)
                XCTAssertFalse(manager.showError)
                done.fulfill()
            }
        }
        wait(for: [done], timeout: 5)
    }

    func testChangingSourcesDuringFetchDiscardsStaleResponse() throws {
        let repository = FavoriteLinks(persistenceController: PersistenceController(inMemory: true))
        try repository.saveArticle(link: Link(link: feed))
        let links = LinkManager(favorLinksManager: repository)
        let fetcher = DeferredRSSFetcher()
        let cache = MemoryRSSStore()
        let manager = FluxViewManager(fetcher: fetcher, store: cache, linkManager: links)
        manager.refresh()
        links.removeLink(IndexSet(integer: 0))
        links.linkTapped = "https://example.com/replacement"
        links.addLink()
        var stale = RSSItem.preview
        stale.sourceURL = feed
        fetcher.completion?([Link(link: feed, status: .checked)], [stale])
        let done = expectation(description: "replacement requested")
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                XCTAssertEqual(fetcher.calls, 2)
                XCTAssertTrue(manager.items.isEmpty)
                XCTAssertTrue(cache.items.isEmpty)
                fetcher.completion?([Link(link: "https://example.com/replacement", status: .checked)], [])
                DispatchQueue.main.async {
                    XCTAssertFalse(manager.inProgress)
                    done.fulfill()
                }
            }
        }
        wait(for: [done], timeout: 5)
    }

    func testCacheBoundAndWriteFailure() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        let store = RSSItemStore(url: directory.appendingPathComponent("cache.json"))
        let items = (0..<1002).map {
            RSSItem(title: "Test", link: "https://example.com/\($0)", description: "", pubDate: "2024-05-15T10:00:00Z")
        }
        try store.save(items)
        XCTAssertEqual(try store.load().count, 1000)
        let blocked = RSSItemStore(url: store.url.appendingPathComponent("nested.json"))
        XCTAssertThrowsError(try blocked.save([]))
    }

    func testManagerReportsCacheWriteFailure() throws {
        let repository = FavoriteLinks(persistenceController: PersistenceController(inMemory: true))
        try repository.saveArticle(link: Link(link: feed))
        let cache = MemoryRSSStore()
        cache.failSave = true
        let fetcher = DeferredRSSFetcher()
        let manager = FluxViewManager(fetcher: fetcher, store: cache,
                                      linkManager: LinkManager(favorLinksManager: repository))
        manager.refresh()
        fetcher.completion?([Link(link: feed, status: .checked)], [])
        let done = expectation(description: "storage error shown")
        DispatchQueue.main.async {
            XCTAssertTrue(manager.showError)
            XCTAssertFalse(manager.inProgress)
            done.fulfill()
        }
        wait(for: [done], timeout: 5)
    }

    func testRefreshRetainsFailedSourceAndRemovesDeletedSources() throws {
        let repository = FavoriteLinks(persistenceController: PersistenceController(inMemory: true))
        try repository.saveArticle(link: Link(link: feed))
        let second = "https://example.com/second"
        try repository.saveArticle(link: Link(link: second))
        let links = LinkManager(favorLinksManager: repository)
        let fetcher = DeferredRSSFetcher()
        let cache = MemoryRSSStore()
        var old = RSSItem.preview
        old.sourceURL = feed
        cache.items = [old]
        let manager = FluxViewManager(fetcher: fetcher, store: cache, linkManager: links)
        XCTAssertEqual(manager.items, [old])
        manager.refresh()
        manager.refresh()
        XCTAssertEqual(fetcher.calls, 1)
        XCTAssertTrue(manager.inProgress)
        var fresh = old
        fresh.link = "https://example.com/new"
        fresh.sourceURL = second
        fetcher.completion?([Link(link: feed, status: .bad), Link(link: second, status: .checked)], [fresh])
        let done = expectation(description: "manager updates on main queue")
        DispatchQueue.main.async {
            XCTAssertFalse(manager.inProgress)
            XCTAssertEqual(Set(manager.items.map(\.id)), Set([old.id, fresh.id]))
            XCTAssertTrue(manager.showError)
            links.removeLink(IndexSet(integer: 0))
            manager.refresh()
            XCTAssertEqual(manager.items, [fresh])
            done.fulfill()
        }
        wait(for: [done], timeout: 5)
    }
}

private final class DeferredRSSFetcher: RSSFetching {
    var calls = 0
    var completion: (([Link], [RSSItem]?) -> Void)?
    func fetchRSS(links: [Link], completion: @escaping ([Link], [RSSItem]?) -> Void) {
        calls += 1
        self.completion = completion
    }
}

private final class MemoryRSSStore: RSSItemStoring {
    var items: [RSSItem] = []
    func load() throws -> [RSSItem] { items }
    var failSave = false
    func save(_ items: [RSSItem]) throws {
        if failSave { throw CocoaError(.fileWriteNoPermission) }
        self.items = items
    }
}

private final class FeedURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        guard let url = request.url else { return }
        if url.path == "/offline" {
            client?.urlProtocol(self, didFailWithError: URLError(.notConnectedToInternet))
            return
        }
        let status = url.path == "/http-error" ? 503 : 200
        let xml = url.path == "/malformed" ? "<rss>" : "<rss><channel><item><title>Test</title><link>https://example.com/article</link></item></channel></rss>"
        let response = HTTPURLResponse(url: url, statusCode: status, httpVersion: nil, headerFields: nil)!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Data(xml.utf8))
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() { }
}

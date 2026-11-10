//
//  RSSFetcher.swift
//  MyNews
//
//  Created by Sébastien DAGUIN
//

import Foundation
import Alamofire

protocol RSSFetching {
    func fetchRSS(links: [Link], completion: @escaping ([Link], [RSSItem]?) -> Void)
}

final class RSSFetcher: RSSFetching {
    private let session: Session

    init(session: Session = .default) {
        self.session = session
    }

    func fetchRSS(links: [Link], completion: @escaping ([Link], [RSSItem]?) -> Void) {
        // Responses and aggregation use the same serial queue, including empty input.
        DispatchQueue.main.async {
            guard !links.isEmpty else {
                completion([], [])
                return
            }
            let group = DispatchGroup()
            var results: [Int: [RSSItem]] = [:]
            var statuses = links.map { Link(link: $0.link, status: .bad) }
            for (index, link) in links.enumerated() {
                guard let url = URL(string: link.link),
                      ["http", "https"].contains(url.scheme?.lowercased() ?? ""),
                      url.host != nil else { continue }
                group.enter()
                let request = URLRequest(url: url, timeoutInterval: 30)
                self.session.request(request).validate(statusCode: 200..<300)
                    .responseData(queue: .main) { response in
                        defer { group.leave() }
                        guard case .success(let data) = response.result,
                              let parsed = RSSParserDelegate.parse(data) else { return }
                        results[index] = parsed.map { item in
                            var item = item
                            item.sourceURL = link.link
                            return item
                        }
                        statuses[index].status = .checked
                    }
            }
            group.notify(queue: .main) {
                let items = links.indices.flatMap { results[$0] ?? [] }
                completion(statuses, results.isEmpty ? nil : RSSItem.sortedUnique(items))
            }
        }
    }
}

final class RSSParserDelegate: NSObject, XMLParserDelegate {
    private(set) var items: [RSSItem] = []
    private var currentItem: RSSItem?
    private var stack: [String] = []
    private var field: String?
    private var fieldDepth = 0
    private var value = ""
    private var supportedRoot = false

    static func parse(_ data: Data) -> [RSSItem]? {
        let parser = XMLParser(data: data)
        parser.shouldResolveExternalEntities = false
        let delegate = RSSParserDelegate()
        parser.delegate = delegate
        guard parser.parse(), delegate.supportedRoot else { return nil }
        return delegate.items
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        let name = elementName.components(separatedBy: ":").last ?? elementName
        stack.append(name)
        if stack.count == 1 { supportedRoot = ["rss", "RDF", "feed"].contains(name) }
        if name == "item" || name == "entry" {
            currentItem = RSSItem(title: "", link: "", description: "", pubDate: "")
        } else if currentItem != nil, field == nil {
            if name == "link", let href = attributeDict["href"],
               attributeDict["rel"] == nil || attributeDict["rel"] == "alternate" {
                currentItem?.link = href
            }
            if ["title", "link", "description", "summary", "encoded", "content",
                "pubDate", "published", "updated", "date"].contains(name) {
                field = name
                fieldDepth = stack.count
                value = ""
            }
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if field != nil { value += string }
    }

    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        if let text = String(data: CDATABlock, encoding: .utf8) {
            self.parser(parser, foundCharacters: text)
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {
        if let field, stack.count == fieldDepth {
            let text = value.trimmingCharacters(in: .whitespacesAndNewlines)
            switch field {
            case "title": currentItem?.title = text
            case "link": if !text.isEmpty { currentItem?.link = text }
            case "description", "summary", "encoded", "content":
                if !text.isEmpty { currentItem?.description = text }
            case "pubDate", "published", "date": currentItem?.pubDate = text
            case "updated": if currentItem?.pubDate.isEmpty == true { currentItem?.pubDate = text }
            default: break
            }
            self.field = nil
        }
        if ["item", "entry"].contains(stack.last ?? ""), let item = currentItem {
            if let url = URL(string: item.link), url.host != nil,
               ["http", "https"].contains(url.scheme?.lowercased() ?? "") {
                items.append(item)
            }
            currentItem = nil
        }
        stack.removeLast()
    }
}

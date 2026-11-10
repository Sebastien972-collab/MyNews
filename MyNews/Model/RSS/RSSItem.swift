//
//  FluxRss.swift
//  MyNews
//
//  Created by Sebby on 20/04/2024.
//

import Foundation


struct RSSItem: Identifiable, Hashable, Equatable, Codable {
    var id: String{
        return self.link
    }
    var sourceURL: String? = nil
    var title: String
    var link: String
    var description: String
    var descriptionDecode: String {
        if let utf8Data = description.data(using: .utf8) {
            if let descriptionDecoded = String(data: utf8Data, encoding: .utf8) {
                return descriptionDecoded
            }
        }
        return description
    }
    var pubDate: String
    var dateFr: String {
        calculateTimeDifference(from: pubDate)
    }
    var hostname: String {
        getHosname()
    }
    
    var publishedDate: Date? {
        Self.parseDate(pubDate)
    }

    private static func parseDate(_ string: String) -> Date? {
        let iso = ISO8601DateFormatter()
        if let date = iso.date(from: string) { return date }
        iso.formatOptions.insert(.withFractionalSeconds)
        if let date = iso.date(from: string) { return date }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        for format in ["EEE, dd MMM yyyy HH:mm:ss Z", "EEE, dd MMM yyyy HH:mm Z",
                       "dd MMM yyyy HH:mm:ss Z"] {
            formatter.dateFormat = format
            if let date = formatter.date(from: string) { return date }
        }
        return nil
    }

    static func sortedUnique(_ items: [RSSItem]) -> [RSSItem] {
        var seen = Set<String>()
        let unique = items.filter { seen.insert($0.id).inserted }
        let dated: [(item: RSSItem, date: Date)] = unique.map {
            (item: $0, date: $0.publishedDate ?? Date.distantPast)
        }
        let sorted = dated.sorted { left, right in
            if left.date == right.date { return left.item.id < right.item.id }
            return left.date > right.date
        }
        return sorted.map { $0.item }
    }

    func calculateTimeDifference(from dateString: String) -> String {
        guard let date = Self.parseDate(dateString) else { return "Inconnu" }
        let minutes = max(0, Int(Date().timeIntervalSince(date) / 60))
        if minutes <= 1 { return "À l'instant" }
        if minutes < 60 { return "\(minutes) minutes" }
        let hours = minutes / 60
        if hours < 24 { return "\(hours) heures" }
        return "\(hours / 24) jours"
    }
    func getHosname() -> String {
        guard let hostComponents =  URLComponents(string: link) else { return "Unknow" }
        if let hostname = hostComponents.host {
            return hostname
        } else {
            return "Unknow"
        }
    }
    
    static let preview = RSSItem(title: "La voiture électrique aux 1000 km d’autonomie bat le record mondial de tenue de route avec ce résultat impressionnant", link: "https://www.frandroid.com/survoltes/voitures-electriques/2018318_la-voiture-electrique-aux-1000-km-dautonomie-bat-le-record-mondial-de-tenue-de-route", description: "La nouvelle IM L6 est une voiture électrique vraiment très impressionnante. Dotée d'une autonomie théorique de plus de 1000 km grâce à une batterie semi-solide, elle annonce une tenue de route hallucinante. Elle vient en effet d'établir un nouveau record du monde pour le test de l'élan (moose test). Et le résultat est hallucinant.", pubDate: "Tue, 14 May 2024 14:55:34 +0000")
}


protocol RSSItemStoring {
    func load() throws -> [RSSItem]
    func save(_ items: [RSSItem]) throws
}

struct RSSItemStore: RSSItemStoring {
    let url: URL

    init(url: URL = URL.applicationSupportDirectory.appendingPathComponent("MyNews/rss-cache.json")) {
        self.url = url
    }

    func load() throws -> [RSSItem] {
        guard FileManager.default.fileExists(atPath: url.path) else { return [] }
        return try JSONDecoder().decode([RSSItem].self, from: Data(contentsOf: url))
    }

    func save(_ items: [RSSItem]) throws {
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(),
                                                withIntermediateDirectories: true)
        let snapshot = Array(RSSItem.sortedUnique(items).prefix(1000))
        try JSONEncoder().encode(snapshot).write(to: url, options: .atomic)
    }
}

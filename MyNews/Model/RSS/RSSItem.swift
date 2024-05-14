//
//  FluxRss.swift
//  MyNews
//
//  Created by Sebby on 20/04/2024.
//

import Foundation


struct RSSItem: Identifiable, Hashable, Equatable {
    var id: String{
        return self.title
    }
    var title: String
    var link: String
    var description: String
    var pubDate: String
    var dateFr: String {
        calculateTimeDifference(from: pubDate)
    }
    var hostname: String {
        getHosname()
    }
    
    func calculateTimeDifference(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        
        if let dateFromString = dateFormatter.date(from: dateString) {
            let currentTime = Date()
            let timeInterval = currentTime.timeIntervalSince(dateFromString)
            
            let hours = Int(timeInterval / 3600)
            let minutes = Int((timeInterval.truncatingRemainder(dividingBy: 3600)) / 60)
            
            if minutes < 60 {
                if minutes <= 1 {
                    return "À l'instant"
                }
                return "\(minutes) minutes"
            } else if hours < 24 {
                return "\(hours) heures"
            } else {
                return "\(hours / 24) jours "
            }
        } else {
            return "Iconnu"
        }
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

//
//  FluxService.swift
//  MyNews
//
//  Created by Sebby on 20/04/2024.
//

import Foundation
import Alamofire



class RSSFetcher {
    func fetchRSS(links: [Link], completion: @escaping ([Link], [RSSItem]?) -> Void) {
        let group = DispatchGroup()
        var rssItems: [RSSItem] = []
        var linksStatusCheck: [Link] = []
        
        for link in links {
            group.enter()
            AF.request(String(link.link.utf8)).response { response in
                defer { group.leave() }
                guard let data = response.data else {
                    let linkChecked = Link(link: link.link, status: .bad)
                    linksStatusCheck.append(linkChecked)
                    completion(linksStatusCheck, nil)
                    return
                }
                
                // Analyse des données XML du flux RSS
                let parser = XMLParser(data: data)
                let rssParserDelegate = RSSParserDelegate()
                parser.delegate = rssParserDelegate
                parser.parse()
                rssItems.append(contentsOf: rssParserDelegate.items)
                let linkChecked = Link(link: link.link, status: .checked)
                linksStatusCheck.append(linkChecked)
            }
            
        }
        group.notify(queue: .main) {
            
            let rssItemsSorted = rssItems.sorted { $0.dateFr < $1.dateFr }
            completion(linksStatusCheck, rssItemsSorted)
        }
    }
}

class RSSParserDelegate: NSObject, XMLParserDelegate {
    var items: [RSSItem] = []
    var currentElement: String = ""
    var currentItem: RSSItem?
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "item" {
            currentItem = RSSItem(title: "", link: "", description: "", pubDate: "")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentItem?.title += string
        case "link":
            currentItem?.link += string
        case "description":
            currentItem?.description += string
        case "pubDate":
            currentItem?.pubDate += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item", let item = currentItem {
            items.append(item)
            currentItem = nil
        }
    }
}




//class FluxService {
//    static var shared = FluxService()
//    private init(){}
//    private var newsSession: NewsSession = NewsSession()
//
//    init(session: NewsSession) {
//        self.newsSession = session
//
//    }
//    func launchSearch(search: String, callback: @escaping (Bool, [ItemRss]?, Error?) -> Void)  {
//        let searchToUrl = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<BaseUrl>>>>>>>>>>>>>>>>>>>>>>>>")
//        let baseUrl = URL(string: "https://www.mac4ever.com/flux/rss/content/all")!
//        print(baseUrl)
//        launchSession(baseUrl: baseUrl) { success, news, error in
//            print(news![0].description)
//            callback(success, news, error)
//        }
//    }
//
//    private func launchSession(baseUrl: URL, callback: @escaping (Bool, [ItemRss]?, Error?) -> Void) {
//
//    }
//}



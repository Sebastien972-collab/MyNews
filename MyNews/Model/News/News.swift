//
//  News.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import Foundation


struct Source : Codable, Hashable {
    let name : String
}
struct Article : Codable, Hashable, Equatable{
    var id: String{
        return self.title
    }
    let source: Source
    let author: String?
    let title: String
    let description: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
    var dateFr: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Format ISO 8601
        guard let date = dateFormatter.date(from: publishedAt) else {
            return publishedAt
        }
        
        dateFormatter.locale = Locale(identifier: "fr_FR") // Format français
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let frenchDate = dateFormatter.string(from: date)
        
        return frenchDate // Affiche "07/01/2024 11:02:52"
    }
    let content : String
    
    static let preview = Article(source: Source(name: "Martinique 1er"), author: "Sébastien Daguin", title: "La plus belle île du monde ", description: "La Martinique est une île française située dans les Caraïbes, qui fait partie des Petites Antilles. Elle est connue pour sa diversité culturelle, sa nature luxuriante et son volcan actif, la montagne Pelée", url: "https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwimgPaV1Mv9AhWST8AKHQ4yDcAQFnoECBEQAQ&url=https%3A%2F%2Ffr.wikipedia.org%2Fwiki%2FMartinique&usg=AOvVaw1p9_L_XithfDYKyOHw93VV", urlToImage: "https://th.bing.com/th/id/OSK.HEROrm9nQusOTJdpd3XZjbfxmw0TtZJDBjP0QpyYhigi_LM?rs=1&pid=ImgDetMain", publishedAt: "21-10-1998", content: "La Martinique est une île des Caraïbes qui fait partie des petites Antilles. Région d'outre-mer de la France, sa culture reflète un mélange distinctif d'influences françaises et antillaises. Sa plus grande ville, Fort-de-France, abrite des collines abruptes, des rues étroites et La Savane, un jardin bordé de boutiques et de cafés dans lequel a été érigée la statue de Joséphine de Beauharnais, première épouse de Napoléon Bonaparte, native de l'île")
}
struct News : Hashable, Codable {
    let articles : [Article]
}

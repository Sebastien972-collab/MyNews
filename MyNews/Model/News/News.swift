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
    let source : Source
    let author : String?
    let title : String
    let description : String
    let url : String
    let urlToImage : String?
    let publishedAt : String
    let content : String
    static let preview = Article(source: Source(name: "Martinique 1er"), author: "Sébastien Daguin", title: "La plus belle île du monde ", description: "Exposer sur l'île", url: "https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwimgPaV1Mv9AhWST8AKHQ4yDcAQFnoECBEQAQ&url=https%3A%2F%2Ffr.wikipedia.org%2Fwiki%2FMartinique&usg=AOvVaw1p9_L_XithfDYKyOHw93VV", urlToImage: "https://www.antoon.fr/wp-content/uploads/2022/09/la-martinique-caraibes.jpg", publishedAt: "21-10-1998", content: "La Martinique est une île des Caraïbes qui fait partie des petites Antilles. Région d'outre-mer de la France, sa culture reflète un mélange distinctif d'influences françaises et antillaises. Sa plus grande ville, Fort-de-France, abrite des collines abruptes, des rues étroites et La Savane, un jardin bordé de boutiques et de cafés dans lequel a été érigée la statue de Joséphine de Beauharnais, première épouse de Napoléon Bonaparte, native de l'île")
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.author == rhs.author && lhs.title == rhs.title
    }
}
struct News : Hashable, Codable {
    let articles : [Article]
}

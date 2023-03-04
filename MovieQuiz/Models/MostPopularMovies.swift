//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 04.03.2023.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case title = "fulltitle"
        case rating = "imbdRating"
        case imageURL = "image"
    }
}

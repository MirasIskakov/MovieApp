//
//  TopRated.swift
//  MovieApp
//
//  Created by Miras Iskakov on 15.05.2024.
//

import Foundation

// MARK: - TopRated
struct TopRatedModel: Codable {
    let page: Int
    let results: [MovieModelResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

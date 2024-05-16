//
//  PopularModel.swift
//  MovieApp
//
//  Created by Miras Iskakov on 16.05.2024.
//

import Foundation

struct PopularModel: Codable {
    let page: Int
    let results: [MovieModelResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

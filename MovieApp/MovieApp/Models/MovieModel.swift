//
//  MovieModel.swift
//  MovieApp
//
//  Created by Miras Iskakov on 12.05.2024.
//

import Foundation

// MARK: - MovieModel
struct MovieModel: Codable {
    let dates: MovieModelDates
    let page: Int
    let results: [MovieModelResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}




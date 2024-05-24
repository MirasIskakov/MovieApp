//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Miras Iskakov on 16.05.2024.
//

import Foundation

class NetworkManager {
    
    let urlImage = "https://image.tmdb.org/t/p/w500"
    let apiKey = "53f2b8593c9cbda990834e04c51c64e8"
    
    lazy var urlComponent: URLComponents = {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.themoviedb.org"
        component.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        return component
    }()
    
}

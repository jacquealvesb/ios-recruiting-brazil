//
//  MovieService.swift
//  movies
//
//  Created by Jacqueline Alves on 03/12/19.
//  Copyright © 2019 jacquelinealves. All rights reserved.
//

import Foundation

public enum MovieError: Error {
    case apiError
    case invalidURL
    case invalidResponse
    case noData
    case serializationError
}

public enum Endpoint {
    case popularMovies
    case movie(Int)
    case search
    case genres
    
    var rawValue: String {
        switch self {
        case .popularMovies:
            return "/movie/popular"
        case .movie(let id):
            return "/movie/\(id)"
        case .search:
            return "/search/movie"
        case .genres:
            return "/genre/movie/list"
        }
    }
}

class MovieService {
    public static let shared = MovieService()
    
    private let apiKey = "094fd8f84048425f068f6965ca8bb6af"
    private let baseAPIURL = "https://api.themoviedb.org/3"
    public var genres: [Int: String] = [:]
    
    public let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return jsonDecoder
    }()
    
    /// Fetches data from API
    /// - Parameters:
    ///   - endpoint: Endpoint in which request is supposed to be made
    ///   - params: Request params
    ///   - completion: Completion handler
    public func fetch(from endpoint: Endpoint, withParams params: [String: String]? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: baseAPIURL) else {
            completion(.failure(MovieError.invalidURL))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
    
        urlComponents.path.append(contentsOf: endpoint.rawValue)
        urlComponents.queryItems = queryItems
        
        URLSession.shared.request(from: urlComponents.url, params: params) { result in
            completion(result)
        }
    }
}

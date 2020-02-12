//
//  APIService.swift
//  movies
//
//  Created by Jacqueline Alves on 03/12/19.
//  Copyright © 2019 jacquelinealves. All rights reserved.
//

import Foundation

public enum APIError: Error {
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

class APIService {
    public static let shared = APIService()
    
    private let apiKey = "094fd8f84048425f068f6965ca8bb6af"
    private let baseAPIURL = "https://api.themoviedb.org/3"
    public var genres: [Int: String] = [:]
    
    public let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return jsonDecoder
    }()

    public func fetch<T: Codable>(from endpoint: Endpoint, withParams params: [String: String]? = nil, completion: @escaping (Result<T, APIError>) -> Void) {
        guard var urlComponents = URLComponents(string: baseAPIURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
    
        urlComponents.path.append(contentsOf: endpoint.rawValue)
        urlComponents.queryItems = queryItems
        
        request(from: urlComponents.url, params: params) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let response = try self.jsonDecoder.decode(T.self, from: data) // Try to decode response
                    completion(.success(response))
                } catch {
                    completion(.failure(.serializationError))
                }
            }
        }
    }
    
    private func request(from url: URL?, params: [String: String]? = nil, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = url else { // Check if request returned an error
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(.failure(.apiError))
                return
            }
            
            // Check if the http response status code is >= 200 and <= 300
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else { // Check if returned any data
                completion(.failure(.noData))
                return
            }
            
            completion(.success(data))
            
        }
        
        task.resume()
    }
}

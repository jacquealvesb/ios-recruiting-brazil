//
//  DataProvider.swift
//  movies
//
//  Created by Jacqueline Alves on 01/12/19.
//  Copyright © 2019 jacquelinealves. All rights reserved.
//

import Foundation
import Combine

protocol DataProvidable {
    var popularMoviesPublisher: CurrentValueSubject<([Movie], Error?), Never> { get }
    var favoriteMoviesPublisher: CurrentValueSubject<([Movie], Error?), Never> { get }
    
    var popularMovies: [Movie] { get }
    var favoriteMovies: [Movie] { get }
    var genres: [Int: String] { get }
    
    func fetchGenres()
    func fetchPopularMovies(page: Int, completion: (() -> Void)?)
    func fetchFavoriteMovies(completion: (() -> Void)?)
    func searchMovie(query: String, completion: @escaping (Result<[Movie], Error>) -> Void)
    func toggleFavorite(withId id: Int)
    func isFavorite(_ id: Int) -> Bool
}

class DataProvider: DataProvidable, ObservableObject {

    public static let shared = DataProvider()
    
    var popularMoviesPublisher = CurrentValueSubject<([Movie], Error?), Never>(([], nil))
    var favoriteMoviesPublisher = CurrentValueSubject<([Movie], Error?), Never>(([], nil))
    
    var popularMovies: [Movie] {
        return self.popularMoviesPublisher.value.0
    }
    
    var favoriteMovies: [Movie] {
        return self.favoriteMoviesPublisher.value.0
    }
    
    var genres: [Int: String] = [:]
    
    // Cancellables
    private var favoriteIdsSubscriber: AnyCancellable?
    
    init() {
        fetchGenres()
        fetchPopularMovies(page: 1)
        
        favoriteIdsSubscriber = UserDefaults.standard.publisher(for: \.favorites)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] favoritesIDs in
                self?.fetchFavorites(withIDs: favoritesIDs)
            })
    }
    
    public func fetchGenres() {
        APIService.shared.fetch(from: .genres) { result in
            switch result {
            case .failure(let error):
                print(error)
                return
                
            case .success(let data):
                do {
                    let genresResponse = try APIService.shared.jsonDecoder.decode(GenresResponse.self, from: data) // Try to decode response
                    guard let genres = genresResponse.genres else { return } // Get list of genres from response
                    
                    let genresDict = genres.reduce([Int: String](), { (dict, genre) -> [Int: String] in // Convert the list of genres to a dictionary
                        var dict = dict
                        dict[genre.id] = genre.name
                        
                        return dict
                    })
                    
                    self.genres = genresDict // Set the dictionaty to the genres of class
                    
                } catch {
                    return
                }
            }
        }
    }
    
    public func fetchPopularMovies(page: Int, completion: (() -> Void)? = nil) {
        APIService.shared.fetch(from: .popularMovies) { result in
            switch result {
            case .failure(let error):
                self.popularMoviesPublisher.send(([], error))
            case .success(let response):
                do {
                    let movieResponse = try APIService.shared.jsonDecoder.decode(MoviesResponse.self, from: response) // Try to decode response
                    let movies = movieResponse.results.map { Movie($0) } // Map response to array of movies
                    
                    self.popularMoviesPublisher.send((movies, nil))
                } catch {
                    self.popularMoviesPublisher.send(([], APIError.serializationError))
                }
            }
            
            completion?()
        }
    }
    
    func fetchFavoriteMovies(completion: (() -> Void)?) {
        self.fetchFavorites(withIDs: UserDefaults.standard.favorites, completion: completion)
    }
    
    private func fetchFavorites(withIDs ids: [Int], completion: (() -> Void)? = nil) {
        let group = DispatchGroup()
        var favorites = [Movie]()
        var fetchError: Error?
        
        for id in ids {
            group.enter()
            
            APIService.shared.fetch(from: .movie(id)) { result in
                switch result {
                case .failure(let error):
                    fetchError = error
                case .success(let response):
                    do {
                        let movieResponse = try APIService.shared.jsonDecoder.decode(MovieDTO.self, from: response) // Try to decode response
                        let movie = Movie(movieResponse)
                        
                        favorites.append(movie)
                    } catch {
                        fetchError = error
                    }
                }
                
                group.leave()
            }
            
            if fetchError != nil {
                break
            }
        }
        
        group.notify(queue: .main) {
            if let error = fetchError {
                self.favoriteMoviesPublisher.send(([], error))
            } else {
                self.favoriteMoviesPublisher.send((favorites, nil))
            }
            
            completion?()
        }
    }
    
    func searchMovie(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        APIService.shared.fetch(from: .search, withParams: ["query": query]) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let data):
                do {
                    let movieResponse = try APIService.shared.jsonDecoder.decode(MoviesResponse.self, from: data) // Try to decode response
                    let movies = movieResponse.results.map { Movie($0) }
                    
                    completion(.success(movies))
                    
                } catch {
                    completion(.failure(APIError.serializationError))
                }
            }
        }
    }
    
    // MARK: - Handle favorites
    func toggleFavorite(withId id: Int) {
        UserDefaults.standard.toggleFavorite(withId: id)
    }
    
    func isFavorite(_ id: Int) -> Bool {
        return UserDefaults.standard.isFavorite(id)
    }
}

//
//  MockedDataProvider.swift
//  movies
//
//  Created by Jacqueline Alves on 01/12/19.
//  Copyright © 2019 jacquelinealves. All rights reserved.
//

import Foundation
import Combine

class MockedDataProvider: DataProvidable {
    
    public static let shared = MockedDataProvider()
    
    var popularMoviesPublisher = CurrentValueSubject<([Movie], Error?), Never>(([], nil))
    var favoriteMoviesPublisher = CurrentValueSubject<([Movie], Error?), Never>(([], nil))
    
    var popularMovies: [Movie] {
        return self.popularMoviesPublisher.value.0
    }
    
    var favoriteMovies: [Movie] {
        return self.favoriteMoviesPublisher.value.0
    }
    
    var genres: [Int: String] = [:]
    
    private var favoriteIds = [0, 1, 2, 5]
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    init() {
        // Initializing movies
        fetchGenres()
        fetchPopularMovies(page: 1)
        fetchFavoriteMovies()
    }
    
    func fetchGenres() {
        self.genres = [
            0: "Animation",
            1: "Comedy",
            2: "Adventure",
            3: "Drama"
        ]
    }
    
    func fetchPopularMovies(page: Int, completion: (() -> Void)? = nil) {
        let movies = [
            Movie(id: 0,
                  title: "The Little Mermaid",
                  posterPath: nil,
                  overview: "This colorful adventure tells the story of an impetuous mermaid princess named Ariel who falls in love with the very human Prince",
                  releaseDate: dateFormatter.date(from: "1989-12-12"),
                  genreIds: [0, 3]),
            Movie(id: 1,
                  title: "The Princess and the Frog",
                  posterPath: nil,
                  overview: "A waitress, desperate to fulfill her dreams as a restaurant owner, is set on a journey to turn a frog prince back into a human being",
                  releaseDate: dateFormatter.date(from: "2009-12-12"),
                  genreIds: [0]),
            Movie(id: 2,
                  title: "Tangled",
                  posterPath: nil,
                  overview: "When the kingdom's most wanted-and most charming-bandit Flynn Rider hides out in a mysterious tower, he's taken hostage by Rapunzel",
                  releaseDate: dateFormatter.date(from: "2010-12-12"),
                  genreIds: [1]),
            Movie(id: 3,
                  title: "Moana",
                  posterPath: nil,
                  overview: "In Ancient Polynesia, when a terrible curse incurred by Maui reaches an impetuous Chieftain's daughter's island",
                  releaseDate: dateFormatter.date(from: "2016-12-12"),
                  genreIds: [1, 2]),
            Movie(id: 4,
                  title: "Zootopia",
                  posterPath: nil,
                  overview: "Determined to prove herself, Officer Judy Hopps, the first bunny on Zootopia's police force",
                  releaseDate: dateFormatter.date(from: "2016-12-12"),
                  genreIds: [1, 2, 3]),
            Movie(id: 5,
                  title: "Shrek Forever After",
                  posterPath: nil,
                  overview: "A bored and domesticated Shrek pacts with deal-maker Rumpelstiltskin to get back to feeling like a real ogre again",
                  releaseDate: dateFormatter.date(from: "2010-12-12"),
                  genreIds: [0, 3])
        ]
        
        popularMoviesPublisher.send((movies, nil))
    }
    
    func fetchFavoriteMovies(completion: (() -> Void)? = nil) {
        favoriteMoviesPublisher.send((self.popularMovies.filter { isFavorite($0.id) }, nil))
    }
    
    func searchMovie(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let movies = self.popularMovies.filter { $0.title.lowercased().contains(query.lowercased()) }
        completion(.success(movies))
    }
    
    func toggleFavorite(withId id: Int) {
        if let idIndex = favoriteIds.firstIndex(of: id) { // Check if given id is on favorites array
            self.favoriteIds.remove(at: idIndex)
            
        } else { // Given id is not on favorites array, so add to it
            self.favoriteIds.append(id)
        }
    }
    
    func isFavorite(_ id: Int) -> Bool {
        return self.favoriteIds.contains(id)
    }
}

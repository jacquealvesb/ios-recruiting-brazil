//
//  MovieDetailsViewModel.swift
//  movies
//
//  Created by Jacqueline Alves on 02/12/19.
//  Copyright © 2019 jacquelinealves. All rights reserved.
//

import Foundation
import Combine

class MovieDetailsViewModel: ObservableObject {
    private static let dateFormatter: DateFormatter = {
        $0.dateFormat = "MMM, YYYY"
        return $0
    }(DateFormatter())
    
    private var movie: Movie
    
    var title: String {
        return self.movie.title
    }
    
    var date: String {
        guard let releaseDate = self.movie.releaseDate else { return "Upcoming" }
        return MovieDetailsViewModel.dateFormatter.string(from: releaseDate)
    }
    
    var genres: String = ""
    
    var overview: String {
        return self.movie.overview
    }
    
    var posterURL: URL {
        return self.movie.posterURL
    }
    
    var toggleFavorite: () -> Void // Toggle favorite handler
    
    // Publishers
    @Published var favorite: Bool
    
    // Cancellables
    private var favoriteIdsSubscriber: AnyCancellable?

    init(of movie: Movie, dataProvider: DataProvidable = DataProvider.shared) {
        self.movie = movie
        self.favorite = dataProvider.isFavorite(self.movie.id)
        self.toggleFavorite = { // Set function to be called when favorite button is clicked
            dataProvider.toggleFavorite(withId: movie.id)
        }
        self.genres = self.getGenresText(dataProvider.genres)
        
        // Observe changes in favorite list and change its state when it does
        self.favoriteIdsSubscriber = dataProvider.favoriteMoviesPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let id = self?.movie.id else { return }
                self?.favorite = dataProvider.isFavorite(id)
            })
    }
    
    private func getGenresText(_ dict: [Int: String]) -> String {
        guard let genres = self.movie.genreIds?.reduce("", { (genres, genre) -> String in
            "\(genres), \(dict[genre] ?? "")"
        }) else {
            return ""
        }
        
        return String(genres.dropFirst(2))
    }
}

// MARK: - Favorite button delegate
extension MovieDetailsViewModel: FavoriteButtonDelegate {
    func click() {
        self.toggleFavorite()
    }
}

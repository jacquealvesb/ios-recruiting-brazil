//
//  MoviesListCoordinator.swift
//  movies
//
//  Created by jacqueline alves barbosa on 19/02/20.
//  Copyright © 2020 jacquelinealves. All rights reserved.
//

import UIKit

class MoviesListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var rootViewController: UINavigationController
    
    let dataProvider: DataProvidable
    
    init(rootViewController: UINavigationController, dataProvider: DataProvidable) {
        self.rootViewController = rootViewController
        self.dataProvider = dataProvider
    }
    
    func start() {
        let viewModel = MovieListViewModel(dataProvider: dataProvider)
        let viewController = MovieListViewController(viewModel: viewModel)
        
        viewModel.delegate = self
        
        self.rootViewController.pushViewController(viewController, animated: false)
    }
}

extension MoviesListCoordinator: MovieListDelegate {
    func showMovieDetails(withViewModel movieViewModel: MovieDetailsViewModel) {
        let viewController = MovieDetailsViewController(viewModel: movieViewModel)
        
        self.rootViewController.pushViewController(viewController, animated: true)
    }
}

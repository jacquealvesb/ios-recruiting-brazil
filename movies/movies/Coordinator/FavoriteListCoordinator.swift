//
//  FavoriteListCoordinator.swift
//  movies
//
//  Created by jacqueline alves barbosa on 19/02/20.
//  Copyright © 2020 jacquelinealves. All rights reserved.
//

import UIKit

class FavoriteListCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UINavigationController
    
    let dataProvider: DataProvidable
    var filterNavigationController: UINavigationController?
    
    init(rootViewController: UINavigationController, dataProvider: DataProvidable) {
        self.rootViewController = rootViewController
        self.dataProvider = dataProvider
    }
    
    func start() {
        let viewModel = FavoriteListViewModel(dataProvider: dataProvider)
        let viewController = FavoriteListViewController(viewModel: viewModel)
        
        viewModel.delegate = self
        
        self.rootViewController.pushViewController(viewController, animated: false)
    }
}

extension FavoriteListCoordinator: FavoriteListDelegate {
    func showMovieDetails(withViewModel movieViewModel: MovieDetailsViewModel) {
        let viewController = MovieDetailsViewController(viewModel: movieViewModel)
        
        self.rootViewController.pushViewController(viewController, animated: true)
    }
    
    func showFilterView(withViewModel viewModel: FilterViewViewModel) {
        viewModel.delegate = self
        
        let viewController = FilterViewController(viewModel: viewModel)
        self.filterNavigationController = UINavigationController(rootViewController: viewController)
        
        self.rootViewController.present(self.filterNavigationController!, animated: true)
    }
}

extension FavoriteListCoordinator: FilterViewDelegate {
    func showFilterOptionsView(withViewModel viewModel: FilterOptionsViewModel) {
        viewModel.delegate = self
        
        let viewController = FilterOptionsViewController(viewModel: viewModel)
        
        self.filterNavigationController?.pushViewController(viewController, animated: true)
    }
}

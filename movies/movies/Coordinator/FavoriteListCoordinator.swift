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
    
    var filterNavigationController: UINavigationController?
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let viewModel = FavoriteListViewModel(dataProvider: DataProvider.shared)
        let viewController = FavoriteListViewController(viewModel: viewModel)
        
        viewModel.coordinator = self
        
        self.rootViewController.pushViewController(viewController, animated: false)
    }
    
    func showMovieDetails(withViewModel movieViewModel: MovieDetailsViewModel) {
        let viewController = MovieDetailsViewController(viewModel: movieViewModel)
        
        self.rootViewController.pushViewController(viewController, animated: true)
    }
    
    func showFilterView(withViewModel viewModel: FilterViewViewModel) {
        viewModel.coordinator = self
        
        let viewController = FilterViewController(viewModel: viewModel)
        self.filterNavigationController = UINavigationController(rootViewController: viewController)
        
        self.rootViewController.present(self.filterNavigationController!, animated: true)
    }
    
    func showFilterOptionsView(withViewModel viewModel: FilterOptionsViewModel) {
        viewModel.coordinator = self
        
        let viewController = FilterOptionsViewController(viewModel: viewModel)
        
        self.filterNavigationController?.pushViewController(viewController, animated: true)
    }
}

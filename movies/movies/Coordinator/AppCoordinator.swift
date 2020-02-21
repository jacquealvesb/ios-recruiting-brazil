//
//  AppCoordinator.swift
//  movies
//
//  Created by jacqueline alves barbosa on 19/02/20.
//  Copyright © 2020 jacquelinealves. All rights reserved.
//

import UIKit

class AppCoordinator: MainCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: TabBarViewController = {
        let viewController = TabBarViewController()
        
        return viewController
    }()
    
    let window: UIWindow?
    let dataProvider = DataProvider()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        guard let window = window else {
            return
        }
        
        setupTabBar()
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    func setupTabBar() {
        let movieListViewController = UINavigationController()
        let favoriteListViewController = UINavigationController()
        
        movieListViewController.tabBarItem = UITabBarItem(title: "Movies",
                                                          image: UIImage(systemName: "list.bullet"),
                                                          tag: 0)
        favoriteListViewController.tabBarItem = UITabBarItem(title: "Favorites",
                                                             image: UIImage(systemName: "heart.fill"),
                                                             tag: 1)
        
        self.rootViewController.viewControllers = [movieListViewController, favoriteListViewController]
        self.rootViewController.delegate = self.rootViewController
        
        let movieListCoordinator = MoviesListCoordinator(rootViewController: movieListViewController, dataProvider: dataProvider)
        let favoriteListCoordinator = FavoriteListCoordinator(rootViewController: favoriteListViewController, dataProvider: dataProvider)
        
        childCoordinators = [movieListCoordinator, favoriteListCoordinator]
        
        movieListCoordinator.start()
        favoriteListCoordinator.start()
    }
}

//
//  Coordinator.swift
//  movies
//
//  Created by jacqueline alves barbosa on 19/02/20.
//  Copyright © 2020 jacquelinealves. All rights reserved.
//

import UIKit

protocol BaseCoordinator {
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

protocol MainCoordinator: BaseCoordinator {
    var rootViewController: TabBarViewController { get set }
}

protocol Coordinator: BaseCoordinator {
    var rootViewController: UINavigationController { get set }
}

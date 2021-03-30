//
//  AppCoordinator.swift
//  Transformers
//
//  Created by Alek Spitzer on 3/27/21.
//

import UIKit

class AppCoordinator: Coordinator, UITabBarControllerDelegate {
    
    // MARK: - Properties
    
    var rootViewController: UIViewController {
        return tabBarController
    }
    
    private let tabBarController = UITabBarController()
    

    // MARK: - Initialization

    override init() {
        super.init()
        
        // Initialize Child Coordinators
        let transformersCoordinator = TransformersCoordinator()
        let battlefieldCoordinator = BattlefieldCoordinator()
        
        // Update View Controllers
        tabBarController.viewControllers = [
            transformersCoordinator.rootViewController,
            battlefieldCoordinator.rootViewController
        ]
        
        setupTabBarController()
        
        // Append to Child Coordinators
        childCoordinators.append(transformersCoordinator)
        childCoordinators.append(battlefieldCoordinator)
    }
    
    private func setupTabBarController() {
        
        tabBarController.delegate = self
        tabBarController.tabBar.items?[0].title = "My Transformers"
        tabBarController.tabBar.items?[1].title = "Battlefield"
    }

    // MARK: - Overrides
    
    override func start() {
        childCoordinators.forEach { (childCoordinator) in
            // Start Child Coordinator
            childCoordinator.start()
        }
    }
    
    
    // MARK: - UITabBarDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let transformersNavigationController = tabBarController.viewControllers?[0] as! UINavigationController
        let transformersViewController = transformersNavigationController.topViewController as! TransformersViewController
        
        let battlefieldNavigationController = tabBarController.viewControllers?[1] as! UINavigationController
        let battlefieldViewController = battlefieldNavigationController.topViewController as! BattlefieldViewController
        
        
        battlefieldViewController.transformers = transformersViewController.transformers
    }
}

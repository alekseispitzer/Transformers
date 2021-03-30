//
//  BattlefieldCoordinator.swift
//  Transformers
//
//  Created by Alek Spitzer on 3/27/21.
//

import UIKit

class BattlefieldCoordinator: Coordinator {

    // MARK: - Properties
    
    var navigationController = UINavigationController()
    
    // MARK: - Public API
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    // MARK: - Overrides
    
    override func start() {
       showBattlefieldView()
    }
    
    // MARK: - Helper Methods
    
    private func showBattlefieldView() {
        let battlefieldViewController = BattlefieldViewController.instantiate()
        navigationController.pushViewController(battlefieldViewController, animated: true)
    }
    
   
}

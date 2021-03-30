//
//  TransformersCoordinator.swift
//  Transformers
//
//  Created by Alek Spitzer on 3/27/21.
//

import UIKit

class TransformersCoordinator: Coordinator {
    
    // MARK: - Properties
    
    let navigationController = UINavigationController()

    // MARK: - Public API
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    // MARK: - Overrides
    
    override func start() {
        showTransformersView()
    }
    
    // MARK: - Helper Methods
    
    private func showTransformersView() {
        let transformersViewController = TransformersViewController.instantiate()
        
        transformersViewController.showTransformerDetailsView = { [weak self] in
            self?.showTransformerDetailsViewController()
        }
        
        transformersViewController.showUpdateTransformerView = { [weak self] transformer in
            self?.showUpdateTransformerView(transformer)
        }
        
        navigationController.pushViewController(transformersViewController, animated: true)
    }
    
    private func showTransformerDetailsViewController() {
        let transformerDetailsViewController = TransformerDetailsViewController.instantiate()
        transformerDetailsViewController.viewType = .newTransformer
        
        
        transformerDetailsViewController.dismiss = { [weak self] in
            self?.navigationController.popViewController(animated: true)
            
        }
        
        navigationController.pushViewController(transformerDetailsViewController, animated: true)
        
    }
    
    private func showUpdateTransformerView(_ transformer: Transformer) {
        let transformerDetailsViewController = TransformerDetailsViewController.instantiate()
        transformerDetailsViewController.viewType = .updateTransformer
        transformerDetailsViewController.transformer = transformer
        
        
        transformerDetailsViewController.dismiss = { [weak self] in
            self?.navigationController.popViewController(animated: true)
            
        }
        
        navigationController.pushViewController(transformerDetailsViewController, animated: true)
        
    }
    
   
}

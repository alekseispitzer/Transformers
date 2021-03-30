//
//  TransformersViewController.swift
//  Transformers
//
//  Created by Alek Spitzer on 3/27/21.
//

import UIKit

/// TransformersViewController: Displays all tranformers
class TransformersViewController: UIViewController, Storyboardable {

    // MARK: - Storyboardable
    
    static var storyboardName: String {
        return "TransformersViewController"
    }

    // MARK: - Properties
    
    let tranformerCellIdentifier = "transformerCell"
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    var transformers = [Transformer]()
    

    // MARK: - Coordinator Navigation Handler
    
    var showTransformerDetailsView: (() -> Void)?
    var showUpdateTransformerView: ((_ transformer: Transformer) -> Void)?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Transformers"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        setupTableView()
        getTransFormers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTransFormers()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "TransformerCell", bundle: nil), forCellReuseIdentifier: tranformerCellIdentifier)
        refreshControl.attributedTitle = NSAttributedString(string: "Loading Transformers")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    @objc func refresh(_ sender: AnyObject) {
       getTransFormers()
    }
    
    @objc func addTapped() {
        showTransformerDetailsView?()
    }
    
    // MARK: - Backend API Call
    
    func getTransFormers() {
        TransformerService().getTransformers { [weak self] (response) in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
            
            
            if let transformers = response?.transformers {
                DispatchQueue.main.async {
                    self?.transformers = transformers
                    self?.transformers.reverse()
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension TransformersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transformers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tranformerCellIdentifier, for: indexPath) as? TransformerCell else {
            return UITableViewCell()
        }
        
        let transformer = transformers[indexPath.row]
        cell.setup(transformer: transformer)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedTransformer = transformers[indexPath.row]
        showUpdateTransformerView?(selectedTransformer)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let transformer = transformers[indexPath.row]
            
            TransformerService().deleteTransformer(transformer: transformer) { (success) in
                guard let success = success else {
                    return
                }
                
                if success {
                    print("Deleted Transformer with ID: \(transformer.id) with success")
                } else {
                    print("An error occurred while deleting Transformer with ID: \(transformer.id)")
                }
            }
            
            transformers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

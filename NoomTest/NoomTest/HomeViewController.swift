//
//  ViewController.swift
//  NoomTest
//
//  Created by Alexander Ge on 06/09/2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.text = NSLocalizedString("Hello! Search for food :D", comment: "")
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var searchController: UISearchController = {
        let resultsView = UIViewController()
        resultsView.view.backgroundColor = .blue
        let search = UISearchController(searchResultsController: resultsView)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.automaticallyShowsSearchResultsController = true
        search.searchBar.placeholder = NSLocalizedString("Search food", comment: "")
        
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        title = NSLocalizedString("Home", comment: "")
        navigationItem.searchController = searchController
        
        view.addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32)
        ])
        
    
    }


}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("update")
    }
}

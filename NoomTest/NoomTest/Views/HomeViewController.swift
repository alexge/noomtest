//
//  ViewController.swift
//  NoomTest
//
//  Created by Alexander Ge on 06/09/2021.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func homeViewController(_ homeViewController: HomeViewController, didRequestShow food: Food)
}

class HomeViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    
    private let searchRequestPerformer: SearchRequestPerformerProtocol
    
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
        listViewController.delegate = self
        let search = UISearchController(searchResultsController: listViewController)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.automaticallyShowsSearchResultsController = true
        search.searchBar.placeholder = NSLocalizedString("Search food", comment: "")
        
        return search
    }()
    
    private var listViewController = ListViewController()
    
    private var searchTimer: Timer?
    
    private var lastDisplayedSearch: String = ""
    
    init(requestPerformer: SearchRequestPerformerProtocol = AFConsumer()) {
        searchRequestPerformer = requestPerformer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        if searchController.searchBar.text != lastDisplayedSearch {
            listViewController.list = []
        }
        searchTimer?.invalidate()
        guard let text = searchController.searchBar.text, text.isEmpty != true, text != lastDisplayedSearch else { return }
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] timer in
            self?.search(text)
        }
    }
    
    private func search(_ searchTerm: String) {
        DispatchQueue.global().async { [weak self] in
            self?.searchRequestPerformer.search(searchTerm) { result in
                DispatchQueue.main.async {
                    guard let currentText = self?.searchController.searchBar.text, result.searchTerm == currentText else { return }
                    switch result.result {
                    case .success(let foods):
                        self?.listViewController.list = foods
                        if foods.isEmpty {
                            self?.showError(.emptyResults)
                        }
                    case .failure(let error):
                        self?.showError(error)
                        self?.listViewController.list = []
                    }
                    self?.lastDisplayedSearch = result.searchTerm
                }
            }
        }
    }
    
    private func showError(_ error: SearchError) {
        let message = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        switch error {
        case .tooShort:
            message.title = NSLocalizedString("Too short!", comment: "")
            message.message = NSLocalizedString("Search term must be at least 3 characters", comment: "")
        case .any, .decode:
            message.title = NSLocalizedString("UH OH", comment: "")
            message.message = NSLocalizedString("Something went WRONG", comment: "")
        case .emptyResults:
            message.title = NSLocalizedString("No results", comment: "")
            message.message = NSLocalizedString("No results for this search, try something different", comment: "")
        }
        let action = UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .default) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        message.addAction(action)
        present(message, animated: true, completion: nil)
    }
}

extension HomeViewController: ListViewControllerDelegate {
    func listViewController(_ listViewController: ListViewController, didSelect food: Food) {
        delegate?.homeViewController(self, didRequestShow: food)
    }
}

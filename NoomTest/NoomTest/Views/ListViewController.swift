//
//  ListViewController.swift
//  NoomTest
//
//  Created by Alexander Ge on 07/09/2021.
//

import UIKit

protocol ListViewControllerDelegate: AnyObject {
    func listViewController(_ listViewController: ListViewController, didSelect food: Food)
}

class ListViewController: UIViewController {
    
    var list: [Food] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: ListViewControllerDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FoodTableViewCell.self, forCellReuseIdentifier: FoodTableViewCell.identifier)
        tableView.tableHeaderView = caloriesHeader
        return tableView
    }()
    
    private var caloriesHeader = CaloriesHeader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func set(_ calories: Double) {
        caloriesHeader.set(calories)
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.listViewController(self, didSelect: list[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FoodTableViewCell.identifier) as? FoodTableViewCell else {
            return UITableViewCell()
        }
        cell.bind(list[indexPath.row])
        return cell
    }
}

//
//  RootNavigationCoordinator.swift
//  NoomTest
//
//  Created by Alexander Ge on 06/09/2021.
//

import UIKit

class RootNavigationCoordinator: UIViewController {
    private var currentChild: UIViewController?
    private var navigationCoordinator = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSearchList()
    }
    
    private func showSearchList() {
        let home = HomeViewController()
        home.delegate = self
        navigationCoordinator.viewControllers = [home]
        show(child: navigationCoordinator)
    }
    
    private func show(child: UIViewController) {
        if let current = currentChild {
            current.view.removeFromSuperview()
            current.removeFromParent()
        }
        addChild(child)
        view.addSubview(child.view)
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        child.view.frame = view.bounds

        child.didMove(toParent: self)
        currentChild = child
        view.backgroundColor = child.view.backgroundColor
    }
}

extension RootNavigationCoordinator: HomeViewControllerDelegate {
    func homeViewController(_ homeViewController: HomeViewController, didRequestShow food: Food) {
        let storyboard = UIStoryboard(name: FoodDetailViewController.identifier, bundle: .main)
        guard let detailVC = storyboard.instantiateViewController(identifier: FoodDetailViewController.identifier) as? FoodDetailViewController else { return }
        let _ = detailVC.view
        detailVC.bind(food)
        navigationCoordinator.pushViewController(detailVC, animated: true)
    }
}

//
//  RootNavigationCoordinator.swift
//  NoomTest
//
//  Created by Alexander Ge on 06/09/2021.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationCoordinator: UINavigationController { get }
    func start()
}

class RootNavigationCoordinator: UIViewController {
    private var currentChild: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSearchList()
    }
    
    private func showSearchList() {
        let home = HomeViewController()
        let navigationController = UINavigationController(rootViewController: home)
        show(child: navigationController)
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

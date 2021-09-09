//
//  FoodDetailViewController.swift
//  NoomTest
//
//  Created by Alexander Ge on 09/09/2021.
//

import UIKit

class FoodDetailViewController: UIViewController {
    
    static let identifier = "FoodDetailViewController"
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var portionLabel: UILabel!
    
    func bind(_ food: Food) {
        idLabel.text = String(food.id)
        brandLabel.text = food.brand
        nameLabel.text = food.name
        caloriesLabel.text = String(food.calories)
        portionLabel.text = String(food.portion)
    }
}

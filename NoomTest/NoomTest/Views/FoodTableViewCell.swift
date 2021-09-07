//
//  FoodTableViewCell.swift
//  NoomTest
//
//  Created by Alexander Ge on 07/09/2021.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
    
    static let identifier = "FoodTableViewCell"
    
    private let brandLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let foodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 4
        sv.contentMode = .left
        sv.distribution = .equalCentering
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: FoodTableViewCell.identifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        contentStack.addArrangedSubview(brandLabel)
        contentStack.addArrangedSubview(foodLabel)
        contentView.addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            contentStack.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 16)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        brandLabel.text = nil
        foodLabel.text = nil
    }
    
    func bind(_ food: Food) {
        brandLabel.text = food.brand
        foodLabel.text = food.name
    }
}

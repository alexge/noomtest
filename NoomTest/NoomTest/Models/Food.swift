//
//  Food.swift
//  NoomTest
//
//  Created by Alexander Ge on 07/09/2021.
//

import Foundation

struct Food: Codable {
    let id: Int
    let name: String
    let brand: String
    // per 100 grams
    let calories: Int
    // grams per portion
    let portion: Int
    
    var caloriesPerPortion: Double {
        let caloriesPerGram = Double(calories) / Double(100)
        return Double(portion) * caloriesPerGram
    }
}

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
    let calories: Int
    let portion: Int
}

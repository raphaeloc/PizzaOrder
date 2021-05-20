//
//  Item.swift
//  PizzaOrder
//
//  Created by Raphael de Oliveira Chagas on 20/05/21.
//

import Foundation

typealias Items = [Item]

struct Item: Codable {
    
    let id: String
    let name: String
    let imageUrl: String
    let rating: Int
    let priceP: Double
    let priceM: Double
    let priceG: Double
}

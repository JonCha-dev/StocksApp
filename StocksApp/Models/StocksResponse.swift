//
//  StocksResponse.swift
//  StocksApp
//
//  Created by Jon Chang on 7/13/23.
//

import Foundation

struct StocksResponse: Decodable {
    var stocks: [Stock]
}

struct Stock: Decodable, Identifiable {
    let id = UUID()
    let ticker: String
    let name: String
    let currency: String
    let current_price_cents: Int
    let quantity: Int?
    let current_price_timestamp: Int
}

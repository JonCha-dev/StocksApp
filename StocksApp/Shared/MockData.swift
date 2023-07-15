//
//  MockData.swift
//  StocksApp
//
//  Created by Jon Chang on 7/13/23.
//

import Foundation

struct MockData {
    static let mockStockNil = Stock(ticker: "^GSPC", name: "S&P 500", currency: "USD", current_price_cents: 318157, quantity: nil, current_price_timestamp: 1681845832)
    static let mockStock = Stock(ticker: "RUNINC", name: "Runners Inc.", currency: "USD", current_price_cents: 3614, quantity: 5, current_price_timestamp: 1681845832)
}

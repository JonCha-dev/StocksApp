//
//  API.swift
//  StocksApp
//
//  Created by Jon Chang on 7/14/23.
//

import Foundation

enum API {
    case main, error, empty
    
    var link: String {
        switch self {
            case .main:
                return "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio.json"
            case .error:
                return "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio_malformed.json"
            case .empty:
                return "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio_empty.json"
        }
    }
}

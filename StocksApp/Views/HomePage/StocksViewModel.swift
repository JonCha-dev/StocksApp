//
//  StocksViewModel.swift
//  StocksApp
//
//  Created by Jon Chang on 7/13/23.
//

import Foundation
import Combine

enum AsyncStatus {
    case initial, loading, loaded, empty, error
}

class StocksViewModel: ObservableObject {
//    let apiType: API
//
//    init(apiType: API) {
//        self.apiType = apiType
//    }
    
    @Published var stocks = [Stock]()
    @Published var status: AsyncStatus = .initial
    
    var cancellable = Set<AnyCancellable>()
    let service: StocksServiceProtocol
    
    init(service: StocksServiceProtocol) {
        self.service = service
    }
    
    func getStocks() {
        status = .loading
        service.fetchStocks()
            .sink {[weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    self?.status = .error
                }
            } receiveValue: { [weak self] stocks in
                self?.stocks = stocks
                
                if stocks.count > 0 {
                    self?.status = .loaded
                } else {
                    self?.status = .empty
                }
            }
            .store(in: &cancellable)
    }
    
    /*
    @MainActor func getStocks() {
        Task {
            do {
                status = .loading
                let stockResponse: StocksResponse = try await service.fetchStocks(apiType)
                self.stocks = stockResponse.stocks
                
                if self.stocks.count > 0 {
                    status = .loaded
                } else {
                    status = .empty
                }
                    
            } catch {
                status = .error
                if let error = error as? APIError {
                    print(error.description)
                } else {
                    print(String(describing: error))
                }
            }
        }
    }*/
}

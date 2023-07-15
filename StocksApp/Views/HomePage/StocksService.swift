//
//  StocksService.swift
//  StocksApp
//
//  Created by Jon Chang on 7/13/23.
//

import Foundation
import Combine

protocol StocksServiceProtocol {
    func fetchStocks() -> Future<[Stock], Error>
}

class StocksService: StocksServiceProtocol {
    var cancellable = Set<AnyCancellable>()
    
    let url = "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio.json"
    
    func fetchStocks() -> Future<[Stock], Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            guard let url = URL(string: url) else { return }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data } // Data
                .decode(type: StocksResponse.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in // subscribing to events coming from publisher
                    switch completion {
                    case .finished:
                        break
                    case .failure(let err):
                        promise(.failure(err))
                    }
                } receiveValue: { response in
                    promise(.success(response.stocks))
                }
                .store(in: &self.cancellable)
        }
    }
    
    /*
    func fetchStocks(_ url: API) async throws -> StocksResponse {
        guard let url = URL(string: url.link) else { throw APIError.invalidUrl }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let resp = response as? HTTPURLResponse, 200..<299 ~= resp.statusCode else {
            throw APIError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(StocksResponse.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }*/
}

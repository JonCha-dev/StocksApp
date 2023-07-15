//
//  StocksAppTests.swift
//  StocksAppTests
//
//  Created by Jon Chang on 7/13/23.
//

import XCTest
import Combine
@testable import StocksApp

enum FileName: String {
    case stocksTestSuccess
    case stocksTestFailure
    case stocksTestEmpty
}

final class StocksAppTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables = []
    }

    func test_getStocks_success() {
        let exp = XCTestExpectation(description: "testing stocks api retrieve success")
        let viewModel = StocksViewModel(service: MockStocksService(fileName: .stocksTestSuccess))
        
        viewModel.getStocks()
        
        viewModel.$status
            .sink { state in
                XCTAssertEqual(state, .loaded)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 5.0)
    }
    
    func test_getStocks_failure_bad_format() {
        let exp = XCTestExpectation(description: "testing stocks api retrieve failure (bad format)")
        let viewModel = StocksViewModel(service: MockStocksService(fileName: .stocksTestFailure))
        
        viewModel.getStocks()
        
        viewModel.$status
            .sink { state in
                XCTAssertEqual(state, .error)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 5.0)
    }
    
    func test_getStocks_empty_result() {
        let exp = XCTestExpectation(description: "testing stocks api retrieve success (empty)")
        let viewModel = StocksViewModel(service: MockStocksService(fileName: .stocksTestEmpty))
        
        viewModel.getStocks()
        
        viewModel.$status
            .sink { state in
                XCTAssertEqual(state, .empty)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 5.0)
    }

}


class MockStocksService: StocksServiceProtocol {
    let fileName: FileName
    
    init(fileName: FileName) {
        self.fileName = fileName
    }
    
    private func loadMockData(_ file: String) -> URL? {
        return Bundle(for: type(of: self)).url(forResource: file, withExtension: "json")
    }
    
    func fetchStocks() -> Future<[StocksApp.Stock], Error> {
        
        return Future { [weak self] promise in
            
            guard let self = self,  let url = self.loadMockData(self.fileName.rawValue) else { return }
            
            let data = try! Data(contentsOf: url)
            
            do {
                let result = try JSONDecoder().decode(StocksResponse.self, from: data)
                promise(.success(result.stocks))
            } catch {
                promise(.failure(APIError.decodingError))
            }
        }
        
    }
}

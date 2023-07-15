//
//  HomeView.swift
//  StocksApp
//
//  Created by Jon Chang on 7/13/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = StocksViewModel(service: StocksService())
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Your Portfolio")
                        .font(.largeTitle)
                        .fontWeight(.medium)
                    Spacer()
                }
                .padding([.leading])
                
                switch viewModel.status {
                case .initial, .loading:
                    Text("Loading...")
                        .padding()
                case .loaded:
                    listView(stocks: viewModel.stocks)
                case .empty:
                    Text("Nothing to be displayed.")
                        .padding()
                case .error:
                    Text("There was an error loading your portfolio.")
                        .padding()
                }
                
                
            }
        }
        .onAppear {
            viewModel.getStocks()
        }
    }
    
    private func listView(stocks: [Stock]) -> some View {
        ForEach(stocks) { stock in
            StockCell(stock: stock)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

//
//  StockCell.swift
//  StocksApp
//
//  Created by Jon Chang on 7/13/23.
//

import SwiftUI

struct StockCell: View {
    let stock: Stock
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(stock.ticker)
                        .bold()
                        .font(.system(size:30))
                    Text(stock.name)
                        .bold()
                        .foregroundColor(Color.gray)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("$\(String(format: "%.2f", Float(stock.current_price_cents)/100))")
                        .font(.system(size: 20))
                        .bold()
                    Text("(\(stock.currency))")
                        .font(.system(size:15))
                        .foregroundColor(Color.gray)
                }
            }
            .padding([.bottom], 5)
        
            HStack {
                Text("As of " + getTimeString(stock.current_price_timestamp))
                    .font(.system(size: 15))
                Spacer()
                Text("Amount: \(String(stock.quantity ?? 0))")
                    .bold()
                    .font(.system(size: 15))
            }
            
        }
        .padding()
        .frame(width:350, height: 100)
        .border(Color.black)
    }
    
    private func getTimeString(_ dt: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = .current
        dateFormatter.dateStyle = .short
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
}


struct StockCell_Previews: PreviewProvider {
    static var previews: some View {
        StockCell(stock: MockData.mockStockNil)
    }
}

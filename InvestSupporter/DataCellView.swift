//
//  DataCellView.swift
//  InvestSupporter
//
//  Created by Matviy Suk on 13.05.2021.
//

import SwiftUI

struct DataCell: View {
    private var stock: Stock
    
    init(stock: Stock) {
        self.stock = stock
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(stock.symbol.uppercased())").font(.bold(.title2)()).padding(1)
                Text("\(stock.longName ?? "")").padding(1)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(String(format: "%.2f", stock.bid ?? ""))").padding(1)
                Text("\(String(format: "%.2f", stock.regularMarketDayRange ?? ""))").padding(1)
            }
        }
    }
}

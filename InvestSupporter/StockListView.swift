//
//  StockListView.swift
//  InvestSupporter
//
//  Created by Matviy Suk on 15.06.2021.
//

import SwiftUI
import StockCharts

struct StockListView: View {
    let editMode: EditMode
    let stock: Stock
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(stock.symbol ?? "".uppercased())").font(.bold(.title2)()).padding(1)
                Text("\(stock.longName ?? "")").lineLimit(1).padding(1)
            }
            Spacer()
            LineChartView(data: stock.chart!.first!.close!.compactMap{$0}, dates: nil, hours: nil, dragGesture: true)
            VStack(alignment: .trailing) {
                Text(stockDataToString(stock.bid)).padding(1)
                Text(marketCapFormer(number: stock.marketCap)).padding(1)
            }.opacity(editMode == .active ? 0.0 : 1.0)
        }
    }
}

// Transform whole number of stock marketCap to shorter view
// with suffix M(million) and B(Billion)
func marketCapFormer(number: Int64?) -> String {
    if number == nil {
        return "N/A"
    } else {
        let digits = (String(number!).count)
        switch digits {
        case (13...15):
            return "\(String(format: "%.2f",(Double(number!) / 1000000000000))) T"
        case (10...12):
            return "\(String(format: "%.2f",(Double(number!) / 1000000000))) B"
        case (6...9):
            return "\(String(format: "%.2f",(Double(number!) / 1000000))) M"
        default:
            return "N/A"
        }
    }
}


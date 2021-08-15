//
//  StocksDataView.swift
//  InvestSupporter
//
//  Created by Matviy Suk on 10.05.2021.
//

import SwiftUI
import iLineChart
import iColor

struct StocksDataView: View {
    @EnvironmentObject var stocksViewModel: StocksViewModel

    @State var choosenStock: Stock
    @State var timeRange: TimeRanges

    private var isStarred: Bool {
        if stocksViewModel.containsStock(stocksViewModel.starredStocks, choosenStock) {
            return true
        } else {
            return false
        }
    }

    var body: some View {
        ScrollView {
            VStack {
                iLineChart(data: choosenStock.chart!.first!.close!.compactMap{$0},
                           title: choosenStock.symbol,
                           style: .dark,
                           lineGradient: .bluPurpl,
                           chartBackgroundGradient: .init(start: .darkPurple, end: .black),
                           canvasBackgroundColor: .black,
                           titleColor: Color.darkBlue,
                           numberColor: .lightPurple,
                           curvedLines: false,
                           cursorColor: .darkPurple,
                           displayChartStats: true,
                           fullScreen: false
                ).frame(minHeight: UIScreen.screenHeight/2, maxHeight: UIScreen.screenHeight/2)
                Divider()
                TimeRangesChooser(choosenStock: $choosenStock, timeRange: $timeRange)
                    .environmentObject(stocksViewModel)
                Divider()
                VStack {
                    Group {
                        formatedDataOutput(header: "Open",
                                           data: String(format: "%.2f", averageValue(of: choosenStock.chart?.first?.open?.compactMap{$0} ?? [0.0])))
                        formatedDataOutput(header: "Close",
                                           data: String(format: "%.2f", averageValue(of: choosenStock.chart?.first?.close?.compactMap{$0} ?? [0.0])))
                        formatedDataOutput(header: "High",
                                           data: String(format: "%.2f", averageValue(of: choosenStock.chart?.first?.high?.compactMap{$0} ?? [0.0])))
                        formatedDataOutput(header: "Low",
                                           data: String(format: "%.2f", averageValue(of: choosenStock.chart?.first?.low?.compactMap{$0} ?? [0.0])))
                        formatedDataOutput(header: "Volume",
                                           data: String(format: "%.2f", averageValue(of: choosenStock.chart?.first?.volume?.compactMap{$0} ?? [0.0])))
                    }
                    Group {
                        formatedDataOutput(header: "MarketCap", data: marketCapFormer(number: choosenStock.marketCap))
                        formatedDataOutput(header: "52-Week H", data: stockDataToString(choosenStock.fiftyTwoWeekHigh))
                        formatedDataOutput(header: "52-Week L", data: stockDataToString(choosenStock.fiftyTwoWeekLow))
                    }
                }.padding(.horizontal)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
        trailing:
            Button(action: {
                stocksViewModel.addStock(choosenStock)
            }, label: {
                Image(systemName: "star.fill")
                    .imageScale(.large)
                    .accentColor(isStarred ? .yellow : .secondary)
            }))
        }
    }

    private func formatedDataOutput(header: String, data: String) -> some View {
        return VStack {
            HStack {
                Text(header).padding(.horizontal)
                Spacer()
                Text(data).padding(.horizontal)
            }
            Divider()
        }
    }
    
    private func averageValue(of arr: [Double]) -> Double {
        var sum: Double = 0.0
        for element in arr {
            sum += element
        }
        return sum / Double(arr.count)
    }
}



// Needs to create generics version of these functions
func stockDataToString(_ data: Int?) -> String {
    if data == nil {
        return "N/A"
    } else {
        return String(format: "%.2i" ,data!)
    }
}

func stockDataToString(_ data: Double?) -> String {
    if data == nil {
        return "N/A"
    } else {
        return String(format: "%.2f" ,data!)
    }
}

func stockDataToString(_ data: String?) -> String {
    if data == nil {
        return "N/A"
    } else {
        return String(data!)
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

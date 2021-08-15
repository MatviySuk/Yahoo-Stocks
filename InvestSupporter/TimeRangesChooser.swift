//
//  TimeRangesChooser.swift
//  InvestSupporter
//
//  Created by Matviy Suk on 17.06.2021.
//

import SwiftUI

struct TimeRangesChooser: View {
    @EnvironmentObject private var stocksViewModel: StocksViewModel
    @Binding var choosenStock: Stock
    @Binding var timeRange: TimeRanges {
        didSet {
            stocksViewModel.getYahooQuote(symbol: choosenStock.symbol!, period: timeRange) { quoteParent in
                let quoteResponse = quoteParent.quoteResponse
                if quoteResponse.error == nil && quoteResponse.result?.first != nil {
                    choosenStock = quoteResponse.result!.first!
                }
            }
        }
    }
    
    var body: some View {
            ScrollView(.horizontal) {
                HStack {
                    Group {
                        Button(action: {
                            timeRange = .oneD
                        }, label: { Text("1D")
                            .bold()
                            .accentColor(timeRange == .oneD ? .purple : .white)
                            .padding(.leading, dividerPadding) })
                        Divider().padding(.horizontal, dividerPadding)
                        Button(action: {
                            timeRange = .oneW
                        }, label: { Text("1W")
                                .bold()
                                .accentColor(timeRange == .oneW ? .purple : .white) })
                        Divider().padding(.horizontal, dividerPadding)
                        Button(action: {
                            timeRange = .oneM
                        }, label: { Text("1M")
                                .bold()
                                .accentColor(timeRange == .oneM ? .purple : .white) })
                        Divider().padding(.horizontal, dividerPadding)
                        Button(action: {
                            timeRange = .threeM
                        }, label: { Text("3M")
                                .bold()
                                .accentColor(timeRange == .threeM ? .purple : .white) })
                        Divider().padding(.horizontal, dividerPadding)
                        Button(action: {
                            timeRange = .sixM
                        }, label: { Text("6M")
                                .bold()
                                .accentColor(timeRange == .sixM ? .purple : .white) })
                        Divider().padding(.horizontal, dividerPadding)
                    }
                    Group {
                        Button(action: {
                            timeRange = .oneY
                        }, label: { Text("1Y")
                                .bold()
                                .accentColor(timeRange == .oneY ? .purple : .white) })
                        Divider().padding(.horizontal, dividerPadding)
                        Button(action: {
                            timeRange = .twoY
                        }, label: { Text("2Y")
                                .bold()
                                .accentColor(timeRange == .twoY ? .purple : .white) })
                        Divider().padding(.horizontal, dividerPadding)
                        Button(action: {
                            timeRange = .fiveY
                        }, label: { Text("5Y")
                                .bold()
                                .accentColor(timeRange == .fiveY ? .purple : .white) })
                        Divider().padding(.horizontal, dividerPadding)
                        Button(action: {
                            timeRange = .tenY
                        }, label: { Text("10Y")
                                .bold()
                                .accentColor(timeRange == .tenY ? .purple : .white) })
                        Divider().padding(.horizontal, dividerPadding)
                        Button(action: {
                            timeRange = .all
                        }, label: { Text("MAX")
                                .bold()
                                .accentColor(timeRange == .all ? .purple : .white) })
                    }
                }
            }
//        }
        .padding(linePadding)
    }
    //MARK: - Drawing constants
    private let dividerPadding: CGFloat = 5
    private let linePadding: CGFloat = 7
}


//struct TimeRangesChooser_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeRangesChooser()
//            .preferredColorScheme(.dark)
//    }
//}

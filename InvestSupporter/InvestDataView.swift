//
//  InvestDataView.swift
//  InvestSupporter
//
//  Created by Matviy Suk on 07.05.2021.
//

import SwiftUI

struct InvestDataView: View {
    @ObservedObject var stocksViewModel: StocksViewModel
    
    @State private var editMode: EditMode = .inactive
    
    @State private var searchText: String = ""
    @State private var showCancelButton: Bool = false
    
    // Used for showing either stock is found during search action or not
    private let errorName = "ERROR"
    
    // Search action. Called when search key pressed on keyboard
    func search() {
        showCancelButton = true
        stocksViewModel.getYahooQuote(symbol: searchText, period: .oneW) { quoteParent in
            if quoteParent.quoteResponse.error == nil &&
                quoteParent.quoteResponse.result?.first != nil &&
                quoteParent.quoteResponse.result?.first?.marketCap != nil
            {
                stocksViewModel.stocks = quoteParent.quoteResponse.result!
            } else {
                stocksViewModel.stocks.removeAll()
                stocksViewModel.stocks.insert(Stock(), at: 0)
                stocksViewModel.stocks[0].longName = errorName
                print("Quote error: \(String(describing: quoteParent.quoteResponse.error))")
            }
        }
        editMode = .inactive
    }
    
    // Cancel action. Called when cancel button of search bar pressed
    func cancel() {
        showCancelButton = false
        stocksViewModel.stocks.removeAll()
    }
    
    var body: some View {
        NavigationView {
            SearchNavigation(text: $searchText, search: search, cancel: cancel) {
                // MARK: - Previus non auto-hide search bar
//                                SearchBar(searchText: $searchText, showCancelButton: $showCancelButton)
//                                    .environmentObject(stocksViewModel)
//                                    .padding(7)
                List {
                    ForEach(showCancelButton ? stocksViewModel.stocks : stocksViewModel.starredStocks, id: \.symbol) { stock in
                        if showCancelButton && stocksViewModel.stocks.first?.longName == errorName {
                            Text("\"\(self.searchText)\" is not found!").padding()
                        } else {
                            NavigationLink(destination: StocksDataView(choosenStock: stock, timeRange: .oneW)
                                            .navigationTitle(stock.longName ?? "")
                                            .environmentObject(stocksViewModel)
                            ) {
                                StockListView(editMode: editMode, stock: stock)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.map { stocksViewModel.starredStocks[$0] }.forEach { stock in
                            stocksViewModel.deleteStock(stock)
                        }
                    }
                }
//                .listStyle(.inset)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Text("Stocks").font(.largeTitle),
                    trailing:
                        HStack {
                    Button(action: {
                        stocksViewModel.updateStarredStocks(save: true)
                    }, label: {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.title3)
                    })
                    .padding(5)
                    .disabled(stocksViewModel.starredStocks.isEmpty)
                    EditButton()
                        .font(.title3)
                })
                .environment(\.editMode, $editMode)
            }
            .navigationTitle(Text(""))
            .navigationBarHidden(true)
        }
        .animation(.easeInOut(duration: 0.25))
        .onAppear {
            stocksViewModel.updateStarredStocks(save: true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let stocks = StocksViewModel()
        InvestDataView(stocksViewModel: stocks)
            .preferredColorScheme(.dark)
    }
}



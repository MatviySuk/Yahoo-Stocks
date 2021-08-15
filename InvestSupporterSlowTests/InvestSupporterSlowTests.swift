//
//  InvestSupporterSlowTests.swift
//  InvestSupporterSlowTests
//
//  Created by Matviy Suk on 15.08.2021.
//

import XCTest
@testable import InvestSupporter

class InvestSupporterSlowTests: XCTestCase {
    var sut: StocksViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = StocksViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testGetStockDataThrowGetYahooQuote() throws {
        // given
        let symbol = "aapl"
        let period = TimeRanges.oneW
        let quoteParent = expectation(description: "Server didn't response or time has left")
        
        // when
        sut.getYahooQuote(symbol: symbol, period: period) { quote in
            // then
            if quote.quoteResponse.result == [] {
                XCTFail("Quote result is empty!")
            } else if quote.quoteResponse.error != nil {
                XCTFail("Error occured during URL session!")
            } else {
                quoteParent.fulfill()
            }
        }
        wait(for: [quoteParent], timeout: 2.0)
    }
}

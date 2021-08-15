//
//  InvestSupporterTests.swift
//  InvestSupporterTests
//
//  Created by Matviy Suk on 14.08.2021.
//

import XCTest
@testable import InvestSupporter

class InvestSupporterTests: XCTestCase {
    var sut: StocksViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = StocksViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testContainsStockWorksProperly() {
        // given
        let stock1 = Stock(symbol: "TSLA")
        let stock2 = Stock(symbol: "AAPL")
        let stock3 = Stock(symbol: "GOOG")
        let array = [stock1, stock2]
        
        // when
        let resultTrue: Bool = sut.containsStock(array, stock2)
        let resultFalse: Bool = sut.containsStock(array, stock3)
        
        // then
        XCTAssertEqual(resultTrue, true, "Function that check does array contains stock works not correctly!")
        XCTAssertEqual(resultFalse, false, "Function that check does array contains stock works not correctly!")
    }
    
    func testArrayContainsStockPerformance() {
        measure(
            metrics: [
        XCTClockMetric(),
        XCTCPUMetric(),
        XCTStorageMetric(),
        XCTMemoryMetric()
            ]
        ) {
            let _ = sut.containsStock([Stock(symbol: "TSLA"), Stock(symbol: "AAPL")], Stock(symbol: "TSLA"))
        }
    }
}

//
//  InvestSupporterUITests.swift
//  InvestSupporterUITests
//
//  Created by Matviy Suk on 14.08.2021.
//

import XCTest

class InvestSupporterUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testSearchBarBehaviour() throws {

    }
}

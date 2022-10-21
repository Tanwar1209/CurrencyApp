//
//  CurrencyDetailsViewModelTests.swift
//  CurrencyAppTests
//
//  Created by Tarun Tanwar on 17/10/22.
//


import XCTest
@testable import CurrencyApp

class CurrencyDetailsViewModelTests: XCTestCase {
    var currencyDetailModel: CurrencyDetailsViewModel?
    var mockAPIService: MockApiService?
    
    override func setUpWithError() throws {
        mockAPIService = MockApiService()
        currencyDetailModel = CurrencyDetailsViewModel(currencyConverterService: mockAPIService!)
    }

    override func tearDownWithError() throws {
        mockAPIService = nil
        currencyDetailModel = nil
    }

    func test_convertCurrency_Call() throws {
        currencyDetailModel?.getConvertedCurrency(fromSymbol: "1.0", toSymbol: ["1.0","2.0"], valueToConvert: "2.0")
        XCTAssert(mockAPIService!.isgetConvertedCurrencyCalled)
    }

    func testGetHistoricalDates() throws {
        guard let convertCurrencyDetailsModel = currencyDetailModel else {
            return
        }
        
        let dates = convertCurrencyDetailsModel.getHistoricalDates()
        XCTAssertNotNil(dates)
        XCTAssertEqual(dates.count, 2)
        
    }
    
    func testGetPopularCurrencySymbols() throws {
        guard let convertCurrencyDetailsModel = currencyDetailModel else {
            return
        }
        
        let popularCurrency = convertCurrencyDetailsModel.getPopularCurrencySymbols()
        XCTAssertNotNil(popularCurrency)
        XCTAssertGreaterThanOrEqual(popularCurrency.count, 10)
    }
}

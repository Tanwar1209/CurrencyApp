//
//  CurrencyConverterViewModal.swift
//  CurrencyAppTests
//
//  Created by Tarun Tanwar on 17/10/22.
//

import XCTest
@testable import CurrencyApp

class CurrencyConverterViewModalTests: XCTestCase {
    var convertCurrencyModel: CurrencyConverterViewModal?
    var mockAPIService: MockApiService?

    override func setUpWithError() throws {
        mockAPIService = MockApiService()
        convertCurrencyModel = CurrencyConverterViewModal(currencyConverterService: mockAPIService!)
    }

    override func tearDownWithError() throws {
        convertCurrencyModel = nil
        mockAPIService = nil
    }

    func test_convertCurrency_Call() throws {
        convertCurrencyModel?.getConvertedCurrency(fromSymbol: "1.0", toSymbol: "1.0", valueToConvert: "2.0")
        XCTAssert(mockAPIService!.isgetConvertedCurrencyCalled)
    }
    
    func test_getValidCurrencySymbols_Call() throws {
        convertCurrencyModel?.getValidCurrencySymbols()
        XCTAssert(mockAPIService!.isgetValidCurrencySymbolsCalled)
    }
}

class MockApiService: CurrencyConverterServiceProtocol {
    var isConvertCurrencyCalled = false
    var isgetValidCurrencySymbolsCalled = false
    var isgetConvertedCurrencyCalled = false
    var completeData: [String : Any] = [String : Any]() // Array of stubs
    var completeClosure: ((Bool, [String : Any]?, NetworkError?) -> ())!

    func getValidCurrencySymbols(completion: @escaping (Bool, [String : Any]?, NetworkError?) -> Void) {
        isgetValidCurrencySymbolsCalled = true
    }

    func getConvertedCurrency(queryItemsDict: [String : String], fromSymbol: String, toSymbol: String?, toArraySymbol: [String]?, valueToConvert: String, completion: @escaping (Bool, String?, [CurrencyModel]?, NetworkError?) -> Void) {
        isgetConvertedCurrencyCalled = true
    }

    func convertCurrency(fromValue: Double, toValue: Double, valueToConvert: Double) -> String {
        isConvertCurrencyCalled = true
        return ""
    }

    func fetchSuccess() {
            completeClosure( true, completeData, nil )
        }

    func fetchFail(error: NetworkError?) {
            completeClosure( false, [String : Any](), error )
        }
}

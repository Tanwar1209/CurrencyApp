//
//  CurrencyConverterViewModal.swift
//  CurrencyApp
//
//  Created by Tarun Tanwar on 17/10/22.
//

import Foundation
import RxCocoa
import RxSwift
class CurrencyConverterViewModal {
    public let currencySymbols: PublishSubject<[String]> = PublishSubject()
    public let convertedValue: PublishSubject<String> = PublishSubject()
    public let error: PublishSubject<NetworkError> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    private var currencyConverterService: CurrencyConverterServiceProtocol

    init(currencyConverterService: CurrencyConverterServiceProtocol) {
        self.currencyConverterService = currencyConverterService
    }

    func getValidCurrencySymbols() {
        self.loading.onNext(true)
        currencyConverterService.getValidCurrencySymbols { success, data, networkError in
            self.loading.onNext(false)
            if success, let data = data {
                if let symbolsData = data[StringConstants.symbolsKey] as? [String: String] {
                    let allSymbols = Array(symbolsData.keys)
                    let sortedSymbols = allSymbols.sorted()
                    self.currencySymbols.onNext(sortedSymbols)
                }
            } else {
                if let error = networkError {
                    self.error.onNext(error)
                }
            }
        }
    }

    func getConvertedCurrency(fromSymbol: String, toSymbol: String, valueToConvert: String) {
        self.loading.onNext(true)
        var queryItemsDict = [String: String]()
        queryItemsDict[StringConstants.baseKey] = StringConstants.euroSymbol
        queryItemsDict[StringConstants.symbolsKey] = fromSymbol + StringConstants.commaString + toSymbol
        currencyConverterService.getConvertedCurrency(queryItemsDict: queryItemsDict, fromSymbol: fromSymbol, toSymbol: toSymbol, toArraySymbol: [], valueToConvert: valueToConvert) { success, resultString, _, networkError  in
            self.loading.onNext(false)
            if success, let convertedString = resultString {
                self.convertedValue.onNext(convertedString)
            } else {
                if let error = networkError {
                    self.error.onNext(error)
                }
            }
        }
    }
}

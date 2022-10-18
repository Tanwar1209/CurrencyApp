//
//  CurrencyDetailsViewModel.swift
//  CurrencyApp
//
//  Created by Tarun Tanwar on 17/10/22.
//

import Foundation
import RxCocoa
import RxSwift
class CurrencyDetailsViewModel {
    public let currencyModel: PublishSubject<[CurrencyModel]> = PublishSubject()
    public let historicalDataModel: PublishSubject<[HistoricalDataModel]> = PublishSubject()
    public let error: PublishSubject<NetworkError> = PublishSubject()
    private var currencyConverterService: CurrencyConverterServiceProtocol
    
    init(currencyConverterService: CurrencyConverterServiceProtocol = CurrencyConverterService()) {
        self.currencyConverterService = currencyConverterService
    }
    func getHistoricalCurrencyData(fromSymbol: String, toSymbol: String, valueToConvert: String, convertedLatestValue: String) {
        var queryItemsDict = [String: String]()
        queryItemsDict[StringConstants.baseKey] = StringConstants.euroSymbol
        queryItemsDict[StringConstants.symbolsKey] = fromSymbol + StringConstants.commaString + toSymbol
        var historicalModel = [HistoricalDataModel]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = StringConstants.dateFormatString
        let dateStr: String = dateFormatter.string(from: NSDate() as Date)
        historicalModel.append(HistoricalDataModel(fromCurrencySymbol: fromSymbol, fromCurrencyValue: valueToConvert, toCurrencySymobl: toSymbol, toCurrencyValue: convertedLatestValue, dateString: dateStr))
        let dispatchGroup = DispatchGroup()
        let datesArray = self.getHistoricalDates()
        for dateString in datesArray {
            dispatchGroup.enter()
            NetworkAdaptor.shared.getDataResponse(urlString: dateString, queryItems: queryItemsDict, completionBlock: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let networkError):
                    if let error = networkError as? NetworkError {
                        self.error.onNext(error)
                    }
                case .success(let dta):
                    if let rates = dta[StringConstants.ratesKey] as? [String: Double] {
                        if let fromValue = rates[fromSymbol], let toValue = rates[toSymbol], let value = Double(valueToConvert) {
                            let convertedValue = self.currencyConverterService.convertCurrency(fromValue: fromValue, toValue: toValue, valueToConvert: value)
                            historicalModel.append(HistoricalDataModel(fromCurrencySymbol: fromSymbol, fromCurrencyValue: valueToConvert, toCurrencySymobl: toSymbol, toCurrencyValue: convertedValue, dateString: dateString))
                        }
                    }
                }
                dispatchGroup.leave()
            })
        }
        dispatchGroup.notify(queue: .main) {
            self.historicalDataModel.onNext(historicalModel)
        }
    }

    func getConvertedCurrency(fromSymbol: String, toSymbol: [String], valueToConvert: String) {
        var queryItemsDict = [String: String]()
        queryItemsDict[StringConstants.baseKey] = StringConstants.euroSymbol
        var symbolData = fromSymbol
        for symbol in toSymbol {
            symbolData += StringConstants.commaString + symbol
        }
        queryItemsDict[StringConstants.symbolsKey] = symbolData
        currencyConverterService.getConvertedCurrency(queryItemsDict: queryItemsDict, fromSymbol: fromSymbol, toSymbol: "", toArraySymbol: toSymbol, valueToConvert: valueToConvert) { success, _, resultModel, networkError  in
            if success, let currencyDataModel = resultModel {
                self.currencyModel.onNext(currencyDataModel)
            } else {
                if let error = networkError {
                    self.error.onNext(error)
                }
            }
        }
    }

    func getHistoricalDates() -> [String] {
        var datesData = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = StringConstants.dateFormatString
        for obj in 0...1 {
            let lastWeekDate = NSCalendar.current.date(byAdding: .day, value: -(1 + obj), to: NSDate() as Date)
            let dateStr: String = dateFormatter.string(from: lastWeekDate!)
            datesData.append(dateStr)
        }
        return datesData
    }
    func getPopularCurrencySymbols() -> [String] {
        return [StringConstants.dollarSymbol, StringConstants.britishPoundSymbol, StringConstants.egyptPoundSymbol, StringConstants.euroSymbol, StringConstants.canadianDollarSymbol, StringConstants.indianRupeeSymbol, StringConstants.australianDollarSymbol, StringConstants.dollarSymbol, StringConstants.japaneseYenSymbol, StringConstants.chineseSymbol, StringConstants.qatarRiyalSymbol, StringConstants.uaeDirhamSymbol, StringConstants.swissFrancSymbol]
    }
}

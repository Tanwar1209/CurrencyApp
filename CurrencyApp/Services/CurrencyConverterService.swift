//
//  CurrencyService.swift
//  CurrencyApp
//
//  Created by Tarun Tanwar on 18/10/22.
//

import Foundation

protocol CurrencyConverterServiceProtocol {
    func getValidCurrencySymbols(completion: @escaping (_ success: Bool, _ results: [String: Any]?, _ error: NetworkError?) -> Void)
    func getConvertedCurrency(queryItemsDict: [String: String], fromSymbol: String, toSymbol: String?, toArraySymbol: [String]?, valueToConvert: String, completion: @escaping (_ success: Bool, _ convertedString: String?,_ currencyDataModel: [CurrencyModel]?, _ error: NetworkError?) -> Void)
    func convertCurrency(fromValue: Double, toValue: Double, valueToConvert: Double) -> String
}

class CurrencyConverterService: CurrencyConverterServiceProtocol {
    func getConvertedCurrency(queryItemsDict: [String: String], fromSymbol: String, toSymbol: String?, toArraySymbol: [String]?, valueToConvert: String, completion: @escaping (Bool, String?, [CurrencyModel]?, NetworkError?) -> Void) {
        NetworkAdaptor.shared.getDataResponse(urlString: APIConstants.latestEndPoint, queryItems: queryItemsDict, completionBlock: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let networkError):
                if let error = networkError as? NetworkError {
                    completion(false, nil, nil, error)
                }
            case .success(let dta):
                if let rates = dta[StringConstants.ratesKey] as? [String: Double] {
                    if let fromValue = rates[fromSymbol], let toValue = rates[toSymbol ?? ""], let value = Double(valueToConvert) {
                        let convertedString = self.convertCurrency(fromValue: fromValue, toValue: toValue, valueToConvert: value)
                        completion(true, convertedString, [], nil)
                        return
                    }
                    if let toArray = toArraySymbol {
                        let currencyDataModel = self.createOtherCurrencyData(toSymbols: toArray, ratesData: rates, fromSymbol: fromSymbol, valueToConvert: valueToConvert)
                        completion(true, "", currencyDataModel, nil)
                    }
                }
            }
        })
    }

    func createOtherCurrencyData(toSymbols: [String], ratesData: [String: Double], fromSymbol: String, valueToConvert: String) -> [CurrencyModel] {
        var model = [CurrencyModel]()
        for symbol in toSymbols {
            if let fromValue = ratesData[fromSymbol], let toValue = ratesData[symbol], let value = Double(valueToConvert) {
                let convertedValue = convertCurrency(fromValue: fromValue, toValue: toValue, valueToConvert: value)
                model.append(CurrencyModel(currencySymbol: symbol, currencyValue: convertedValue))
            }
        }
        return model
    }

    func convertCurrency(fromValue: Double, toValue: Double, valueToConvert: Double) -> String {
         let convertValue = (toValue * valueToConvert) / fromValue
        return String(format: "%.3f", convertValue)
    }

    func getValidCurrencySymbols(completion: @escaping (Bool, [String: Any]?, NetworkError?) -> Void) {
            NetworkAdaptor.shared.getDataResponse(urlString: APIConstants.symbolsEndPoint, completionBlock: { [weak self] result in
                guard self != nil else {return}
                       switch result {
                       case .failure(let networkError):
                           if let error = networkError as? NetworkError {
                               completion(false, nil, error)
                           }
                       case .success(let dta):
                           if (dta[StringConstants.symbolsKey] as? [String: String]) != nil {
                               completion(true, dta, nil)
                           }
                       }
                   })
    }
}

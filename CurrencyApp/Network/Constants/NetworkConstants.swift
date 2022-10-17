//
//  NetworkConstants.swift
//  CurrencyApp
//
//  Created by Tarun Tanwar on 17/10/22.
//

import Foundation

protocol CoreNetworkConstantAdapter {
    static var networkPlistFileName: String { get }
}

struct NetworkConstants : CoreNetworkConstantAdapter {
    
    static var networkPlistFileName: String {
        return AppConstants.networkURLFile
    }

    static var networkAdapterKey: String {
        return AppConstants.currencyServiceAdapter
    }
}

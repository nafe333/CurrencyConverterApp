//
//  GetCompareCurrency.swift
//  ConCurrency
//
//  Created by Ahmed Shehata on 27/08/2023.
//

import Foundation

// MARK: - GetCompareCurrency
struct GetCompareCurrency: Codable {
    let from, to: String
    let value: Double
}

typealias GetCompareCurrencies = [GetCompareCurrency]

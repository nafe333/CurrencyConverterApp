//
//  GetLiveExchangeRate.swift
//  ConCurrency
//
//  Created by Ahmed Shehata on 26/08/2023.
//

import Foundation

struct GetLiveExchangeRate: Codable {
    let from, to: String
    let rate: Double
}

typealias GetLiveExchangeRates = [GetLiveExchangeRate]

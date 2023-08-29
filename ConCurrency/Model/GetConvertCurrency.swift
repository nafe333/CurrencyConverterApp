//
//  GetConvertCurrency.swift
//  ConCurrency
//
//  Created by Ahmed Shehata on 26/08/2023.
//

import Foundation

// MARK: - GetConvertCurrency

struct GetConvertCurrency: Codable {
    let from, to: String
    let value: Double
}

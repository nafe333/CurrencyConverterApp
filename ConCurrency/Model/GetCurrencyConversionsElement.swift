// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getCurrencyConverter = try? JSONDecoder().decode(GetCurrencyConverter.self, from: jsonData)

import Foundation

// MARK: - GetCurrencyConverterElement
struct GetCurrencyConversionsElement: Codable {
    let code: String
    let flagURL: String
    let desc: String

    enum CodingKeys: String, CodingKey {
        case code
        case flagURL = "flagUrl"
        case desc
    }
}

typealias GetCurrencyConversions = [GetCurrencyConversionsElement]

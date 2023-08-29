//
//  Constants.swift
//  ConCurrency
//
//  Created by Nafea Elkassas on 23/08/2023.
//

import Foundation
import Alamofire

let httpHeader = HTTPHeaders(Constants.headers)

struct Constants {
//    struct URLs {
//        static let employees = "https://dummy.restapiexample.com/api/v1/employees"
//        static let currencyConversionsUrl = "https://currency-converter-production-3e05.up.railway.app/api/currency-conversions/currencies"
//        static let getLiveExchangeRatesBaseUrl = "https://currency-converter-production-3e05.up.railway.app/api/currency-conversions/rates?from="
//        static let getLiveExchangeRatesUrl = "\(getLiveExchangeRatesBaseUrl)" + "USD" + "&to=" + "EGP" + "," + "EUR"
//        static let getConvertCurrencyBaseURL = "https://currency-converter-production-3e05.up.railway.app/api/currency-conversions/convert?from="
//        static let getConvertCurrencyURL = "\(getConvertCurrencyBaseURL)" + "USD" + "&to=" + "EGP" + "&amount=" + "100"
//
//        static let getComparecurrenciesBaseURL = "https://currency-converter-production-3e05.up.railway.app/api/currency-conversions/compare?from="
//        static let getComparecurrenciesURL = "\(getComparecurrenciesBaseURL)" + "USD" + "&to=" + "EGP" + "," + "GBP" + "&amount=" + "1000"
//
//    }
    struct URLs {
        static let currencyConversionsUrl = "http://ec2-3-144-40-233.us-east-2.compute.amazonaws.com:8000/api/currency-conversions/currencies"
                static let getLiveExchangeRatesBaseUrl = "http://ec2-3-144-40-233.us-east-2.compute.amazonaws.com:8000/api/currency-conversions/rates?from="
                static let getLiveExchangeRatesUrl = "\(getLiveExchangeRatesBaseUrl)" + "USD" + "&to=" + "EGP" + "," + "EUR"
                static let getConvertCurrencyBaseURL = "http://ec2-3-144-40-233.us-east-2.compute.amazonaws.com:8000/api/currency-conversions/convert?from="
                static let getConvertCurrencyURL = "\(getConvertCurrencyBaseURL)" + "USD" + "&to=" + "EGP" + "&amount=" + "100"
                static let getComparecurrenciesBaseURL = "http://ec2-3-144-40-233.us-east-2.compute.amazonaws.com:8000/api/currency-conversions/compare?from="
                static let getComparecurrenciesURL = "\(getComparecurrenciesBaseURL)" + "USD" + "&to=" + "EGP" + "," + "GBP" + "&amount=" + "1000"
        
    }

    static let exchangeRatesParameters: Parameters = ["from": ["CAD"], "to": ["EGP", "EUR"]]
    static let convertCurrencyParameters: Parameters = ["from": ["USD"], "to": ["EGP"], "amount": ["100"]]
    static let compareCurrenciesParameters: Parameters = ["from": ["USD"], "to": ["EGP", "GBP"], "amount": ["1000"]]


    static let headers = ["Content-Type":"application/json"]
 
}







//
//  ApiManager.swift
//  ConCurrency
//
//  Created by Nafea Elkassas on 23/08/2023.
//

import Foundation
import Alamofire

class APIManager {
    
    var currencyConversions: GetCurrencyConversions?
    var liveExchangeRate: GetLiveExchangeRates?
    var convertCurrency: GetConvertCurrency?
    var compareCurrencies: GetCompareCurrencies?
    
    var currenciesList: GetCurrencyConversions = []
//    var currencyFlag: [String] = []
//    var currencyDesc: [String] = []
    
    var liveExchangeFromArr: [String] = []
    var liveExchangeToArr: [String] = []
    var liveExchangeRateArr: [Double] = []
    
    
    //done
    func getCurrencyConversionsData( callback: @escaping ((GetCurrencyConversions)?) -> Void)  {
        AF.request(Constants.URLs.currencyConversionsUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: httpHeader).response { [self] (response) in
            
            switch response.result{
                
            case .success(_):
                
                guard let data = response.data else {return}
                
                do{
                    self.currencyConversions = try JSONDecoder().decode(GetCurrencyConversions.self, from: data)
                    self.currenciesList = currencyConversions ?? []
                    callback(currenciesList)
                    
                } catch {
                    callback( nil )
                    print(error.localizedDescription)
                }
                
            case .failure(_):
                callback( nil )
                print(response.error?.localizedDescription ?? "")
            }
        }
        
    }
    // in progress
//    func getLiveExchangeRatesData(url: String) {
//            AF.request(Constants.URLs.getLiveExchangeRatesUrl, method: .get, parameters:Constants.exchangeRatesParameters, encoding: URLEncoding.default, headers: httpHeader).response { response in
//
//            switch response.result{
//
//            case .success(_):
//
//                guard let data = response.data else {return}
//
//                do{
//                    self.liveExchangeRate = try JSONDecoder().decode(GetLiveExchangeRates.self, from: data)
//                    guard let liveExchangeRate = self.liveExchangeRate else {return}
//
//                    for code in liveExchangeRate {
//
//                        self.liveExchangeFromArr.append(code.from)
//                        self.liveExchangeToArr.append(code.to)
//                        self.liveExchangeRateArr.append(code.rate)
//
//                    }
//                }catch{
//                    print(error.localizedDescription)
//                }
//
//
//            case .failure(_):
//                print(response.error?.localizedDescription ?? "")
//            }
////            print(self.liveExchangeFromArr)
////            print(self.liveExchangeToArr)
////            print(self.liveExchangeRateArr)
//        }
//    }
        // updated get live exchange rate function
//    func getLiveExchangeRatesData(url: String, parameters: Parameters) {
//        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: httpHeader).response { response in
//
//            switch response.result {
//            case .success(_):
//                guard let data = response.data else { return }
//
//                do {
//                    self.liveExchangeRate = try JSONDecoder().decode(GetLiveExchangeRates.self, from: data)
//                    guard let liveExchangeRate = self.liveExchangeRate else { return }
//
//                    for code in liveExchangeRate {
//                        self.liveExchangeFromArr.append(code.from)
//                        self.liveExchangeToArr.append(code.to)
//                        self.liveExchangeRateArr.append(code.rate)
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                }
//
//            case .failure(_):
//                print(response.error?.localizedDescription ?? "")
//            }
//        }
//    }
    
    // second update
//    func getLiveExchangeRatesData(url: String, fromParameter: [String], completion: @escaping (GetLiveExchangeRates) -> Void) {
//    // 1- get the rates for the favArr
//        // 2- now you have the rate we can uwe them to use them to get the flages from the cach
//
//        AF.request(url, method: .get, ["EGP", "USD"], encoding: URLEncoding.default, headers: httpHeader).response { response in
//
//            switch response.result {
//            case .success(_):
//                guard let data = response.data else {
//                    completion([])
//                    return
//                }
//
//                do {
//                    self.liveExchangeRate = try JSONDecoder().decode(GetLiveExchangeRates.self, from: data)
//                    guard let liveExchangeRate = self.liveExchangeRate else {
//                        completion([])
//                        return
//                    }
//
//                    completion(liveExchangeRate)
//                } catch {
//                    print(error.localizedDescription)
//                    completion([])
//                }
//
//            case .failure(_):
//                print(response.error?.localizedDescription ?? "")
//                completion([])
//            }
//        }
//    }
    
    func getLiveExchangeRatesData(from: String, toParameter: [String], completion: @escaping (GetLiveExchangeRates) -> Void) {
      var url = "http://ec2-3-144-40-233.us-east-2.compute.amazonaws.com:8000/api/currency-conversions/rates?from=\(from)"
        var toString = ""
        for param in toParameter {
            toString += param + ","
        }
        url +=  "&to=" + toString
        url.removeLast()
        
        var request = URLRequest(url: URL.init(string: url)!)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion([])
                return
            }
            
            guard let data = data else {
                completion([])
                return
            }

            do {
                let liveExchangeRate = try JSONDecoder().decode(GetLiveExchangeRates.self, from: data)
                completion(liveExchangeRate)
            } catch {
                print(error.localizedDescription)
                completion([])
            }
        }
        
        task.resume()
    }

    // done
    func getConvertCurrencyData(url: String, parameters: Parameters, completion: @escaping (String?) -> Void) {
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: httpHeader).response { response in

            switch response.result {
            case .success(_):
                guard let data = response.data else {
                    completion(nil)
                    return
                }

                do {
                    let convertCurrency = try JSONDecoder().decode(GetConvertCurrency.self, from: data)
                    let convertedValue = convertCurrency.value  // Assuming `value` is the property you want to display
                    completion("\(convertedValue)")
                } catch {
                    print(error.localizedDescription)
                    completion(nil)
                }

            case .failure(_):
                print(response.error?.localizedDescription ?? "")
                completion(nil)
            }
        }
    }

    // done
    func getCompareCurrenciesData(url: String, parameters: Parameters, completion: @escaping (String?, String?) -> Void) {
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: httpHeader).response { response in

            switch response.result {
            case .success(_):
                guard let data = response.data else {
                    completion(nil, nil)
                    return
                }

                do {
                    self.compareCurrencies = try JSONDecoder().decode(GetCompareCurrencies.self, from: data)
                    guard let compareCurrencies = self.compareCurrencies, compareCurrencies.count >= 2 else {
                        completion(nil, nil)
                        return
                    }

                    // Assuming `value` is a property of your data structure
                    let firstValue = compareCurrencies[0].value
                    let secondValue = compareCurrencies[1].value
                    
                    completion("\(firstValue)", "\(secondValue)")
                } catch {
                    print(error.localizedDescription)
                    completion(nil, nil)
                }

            case .failure(_):
                print(response.error?.localizedDescription ?? "")
                completion(nil, nil)
            }
        }
    }
}


    
    
    
    


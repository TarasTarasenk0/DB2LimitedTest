//
//  ApiService.swift
//  DB2LimitedTest
//
//  Created by md760 on 7/11/19.
//  Copyright © 2019 md760. All rights reserved.
//  https://api.privatbank.ua/p24api/exchange_rates?json&date=01.12.2018

import Foundation
import UIKit

final class Singleton {
    static let shared = Singleton()
    
    private init() {}
    
    enum DataError: String, Error, LocalizedError {
        case error = "Error"
        var errorDescription: String? { return rawValue }
    }
    
    
    func fetchRequest(urlString: String, complition: @escaping (([PrivatBankModel], [NBUExchangeRateModel])?, Error?) -> () ) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                complition(nil, error)
                return }
            
            guard let unwrappedData = data else {
                complition(nil, DataError.error)
                return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers)
                
                DispatchQueue.main.async {
                    complition(self.currencyDataFromJson(json), nil)
                }
                
            } catch let jsonError {
                complition(nil, jsonError)
            }
            }.resume()
    }
    
    private func currencyDataFromJson(_ json: Any?) -> ([PrivatBankModel], [NBUExchangeRateModel]) {
        
        var pbModels = [PrivatBankModel]()
        var nbuModels = [NBUExchangeRateModel]()
        
        if let data = json as? [String: Any],
            let clearData = data["exchangeRate"] as? [[String: Any]] {
            for dataDictionary in clearData  {
                
                if let currency = dataDictionary["currency"] as? String,
                    let purchaseRate = dataDictionary["purchaseRate"] as? Double,
                    let saleRate = dataDictionary["saleRate"] as? Double,
                    purchaseRate > 0.0, saleRate > 0.0
                {
                    var pbModel = PrivatBankModel()
                    pbModel.currency = currency
                    pbModel.purchaseRate = purchaseRate
                    pbModel.saleRate = saleRate
                    pbModels.append(pbModel)
                }
                if let purchaseRateNB = dataDictionary["purchaseRateNB"] as? Double,
                    let currency = dataDictionary["currency"] as? String,
                    let baseCurrency = dataDictionary["baseCurrency"] as? String
                {
                    var nbuModel = NBUExchangeRateModel()
                    nbuModel.currency = currency
                    nbuModel.purchaseRateNB = purchaseRateNB
                    nbuModel.baseCurrency = baseCurrency
                    nbuModels.append(nbuModel)
                }
            }
        }
        return (pbModels, nbuModels)
    }
}

//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol coinManagerDeligate {
    func didUpdate(_ coinManager:CoinManager, _ CoinModel: CoinStructForDecodingJson)
    func didFailedwithError(_ error: Error)
}

struct CoinManager {
    
    var baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    var apiKey = "3D3A5C8D-1C47-4954-9745-35190335C74E"
    
    var currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var deligate: coinManagerDeligate?
    
    func performRequest(baseURL : String, apiKey: String, Currency: String )
    {
        let URLSTRING = "\(baseURL)/\(Currency)/apikey-\(apiKey)"
        let URL = URL(string: URLSTRING)
        
        // create URL Session
        let session = URLSession(configuration: .default)
        
        //Give session task
        
        let task = session.dataTask(with: URL!){(data, UrlResponce,error) in
            if error != nil {
                print(error!)
                deligate?.didFailedwithError(error!)
            }
            else{
                if let safeData = data {
                    if let CoinModle = self.parseJSON(data: safeData){
                        deligate?.didUpdate(self, CoinModle)
                    }
                    
                }
            }
        }
        
        // start the task
        
        task.resume()
        
    }
    func getCoinPrice(for currency: String)
    {
        performRequest(baseURL: baseURL, apiKey: apiKey, Currency: currency)
    }
    
    func parseJSON(data: Data) -> CoinStructForDecodingJson?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinStructForDecodingJson.self, from: data)
            print(decodedData.rate)
            let rate = decodedData.rate
            let CoinRate = CoinStructForDecodingJson(rate: rate)
            
            return CoinRate
            
        }catch{
            print(error)
            deligate?.didFailedwithError(error)
            return nil
        }
        
    }

    
}

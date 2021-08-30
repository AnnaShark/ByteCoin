//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "59944E3F-5275-4706-A7AA-83B5D25A2EC9"
   
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func parseJSON(_ data: Data)-> Float?{
        let decoder = JSONDecoder()
        
        do{
           let decodedData =  try decoder.decode(CoinData.self, from: data)
           let lastPrice = decodedData.rate
           return lastPrice
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString){
            // 2. Create a URLSession > thing that can perform networing
            let session = URLSession(configuration: .default)
            // 3. Give session a task
            //let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                //print("error")
                    return
                }
                
                if let safeData = data{
                    if let rate = self.parseJSON(safeData){
                        self.delegate?.didUpdateRate(self, rate:rate, curr: currency)
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
}

protocol CoinManagerDelegate {
    func didUpdateRate(_ coinManager: CoinManager, rate: Float, curr: String)
    func didFailWithError(error: Error)
}

//
//  CurrencyTrackerViewController.swift
//  CurrencyMonitor
//
//  Created by User on 2/26/20.
//  Copyright © 2020 jheisecke. All rights reserved.
//

import UIKit

class CurrencyTrackerViewController: UIViewController {
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var amount2: UILabel!
    @IBOutlet weak var amount3: UILabel!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Por ahora solo mostramos bitcoin
        title = "Bitcoin Tracker"
        
        if let usdPrice = defaults.string(forKey: "USD") {
            amount.text = usdPrice
        }
        if let pygPrice = defaults.string(forKey: "PYG") {
            amount2.text = pygPrice
        }
        if let eurPrice = defaults.string(forKey: "EUR") {
            amount3.text = eurPrice
        }
        
        
        callCurrencyMonitorAPI()
    }

    func callCurrencyMonitorAPI(){
        if let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,EUR,PYG"){
            URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, errorResponse:Error?) in
                if errorResponse == nil{
                    if let pricesJSON = data {
                        if let json = try? JSONSerialization.jsonObject(with: pricesJSON, options: []) as? [String:Double]{
                            DispatchQueue.main.async {
                                if let usdPrice = json["USD"] {
                                    let price = self.getFormattedToCurrency(price: usdPrice, currencyCode: "USD")
                                    self.amount.text = price
                                    self.defaults.set("\(price)~", forKey: "USD")
                                }
                                if let pygPrice = json["PYG"] {
                                    let price = self.getFormattedToCurrency(price: pygPrice, currencyCode: "PYG")
                                    self.amount2.text = price
                                    self.defaults.set("\(price)~", forKey: "PYG")
                                }
                                if let eurPrice = json["EUR"] {
                                    let price = self.getFormattedToCurrency(price: eurPrice, currencyCode: "EUR")
                                    self.amount3.text = price
                                    self.defaults.set("\(price)~", forKey: "EUR")
                                }
                            }
                        }
                    }
                }else{
                    print(errorResponse!)
                }
            }.resume()
        }
    }
    
    func getFormattedToCurrency(price: Double, currencyCode: String) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        if let priceFormatted = formatter.string(from: NSNumber(value: price)) {
            return priceFormatted
        }
        return "An error has occurred"
    }
    
    @IBAction func refreshAmount(_ sender: Any) {
        callCurrencyMonitorAPI()
    }
    
}


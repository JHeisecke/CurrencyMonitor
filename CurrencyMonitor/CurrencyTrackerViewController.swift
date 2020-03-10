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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Por ahora solo mostramos bitcoin
        title = "Bitcoin Tracker"
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
                                    self.amount.text = self.getFormattedToCurrency(price: usdPrice, currencyCode: "USD")
                                }
                                if let pygPrice = json["PYG"] {
                                    self.amount2.text = self.getFormattedToCurrency(price: pygPrice, currencyCode: "PYG")
                                }
                                if let eurPrice = json["EUR"] {
                                    self.amount3.text = self.getFormattedToCurrency(price: eurPrice, currencyCode: "EUR")
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


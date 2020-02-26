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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Por ahora solo mostramos bitcoin
        title = "Bitcoin Tracker"
    }

    @IBAction func refreshAmount(_ sender: Any) {
        
        
    }
    
}


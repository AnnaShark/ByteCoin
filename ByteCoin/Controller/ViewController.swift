//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    var coinManager = CoinManager()

    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }

}

//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    func didUpdateRate(_ coinManager: CoinManager, rate: Float, curr: String){
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.2f",rate)
            self.currencyLabel.text = curr
        }
    }
    
    func didFailWithError(error: Error) {
        print("Here is my error \(error)")
    }
}


//MARK: - UIPickerView DataSource & Delegate
extension ViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency =  coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
    
}


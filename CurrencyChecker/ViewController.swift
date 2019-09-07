//
//  ViewController.swift
//  CurrencyChecker
//
//  Created by Lloyd Blake on 06/09/2019.
//  Copyright © 2019 Lloyd Blake. All rights reserved.
//
import Alamofire
import SwiftyJSON
import UIKit

class ViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {
    
    let baseURL = "http://data.fixer.io/api/latest?access_key=[NEED TO ADD YOUR API KEY HERE]&symbols="
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    var currencySelected = " "
    
    var finalURL = " "
    
    var formatter = "&format=1"
    
    var spacer = " "
    
    @IBOutlet weak var currencyPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
    }


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencySymbolArray[row] + currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencySelected = currencyArray[row]
        finalURL =  baseURL + currencyArray[row] + formatter
        
        getCurrencyData(url: finalURL)

    }
    
    //MARK: - Networking
    /***************************************************************/

func getCurrencyData(url: String){
    
    Alamofire.request(url, method: .get)
        .responseJSON { response in
            if response.result.isSuccess {
                print("Success! Got the Currency data")
                let currencyJSON: JSON  = JSON(response.result.value!)
                print(currencyJSON)
                
                self.updateCurrencyData(json: currencyJSON)
            } else {
                print("Error: \(String(describing: response.result.error))")
                self.currencyPriceLabel.text = "Connection Issues"
            }
            
    }

 }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateCurrencyData(json: JSON) {
        
        if let currencyResult = json["rates"][currencySelected].double {
            currencyPriceLabel.text = currencySelected + spacer + String(currencyResult)
        } else {
            currencyPriceLabel.text = "Price Not Available"
        }
        
    }
}

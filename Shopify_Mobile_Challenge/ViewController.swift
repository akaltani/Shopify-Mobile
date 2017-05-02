//
//  ViewController.swift
//  Shopify_Mobile_Challenge
//
//  Created by First Last on 2017-04-29.
//  Copyright © 2017 First Last. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var label_revenue: UILabel!
    @IBOutlet weak var label_keyboards: UILabel!
    
    var base_url            : String   = "https://shopicruit.myshopify.com/admin/orders.json?page="
    var token_param         : String   = "&access_token="
    var token               : String   = "c32313df0d0ef512ca64d5b336a0d7c6"
    var page                : Int      = 1
    
    var json                : JSON!
    
    var total_order_revenue : Double   = 0.0;
    var num_keyboard        : Int      = 0;
    
    func outputValues() {
        
        let url = NSURL(string: base_url + String(page) + token_param + token)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            
            self.json = JSON(data: data!);
            
            if let value = self.json["orders"].array {
                
                if (value.count > 0) {
                    
                    // process request
                    
                    for item in value {
                        
                        self.total_order_revenue += Double(item["total_price"].string!)!
                        
                        for subitem in item["line_items"].array! {
                            
                            if (subitem["title"].string! == "Aerodynamic Cotton Keyboard") {
                                
                                self.num_keyboard += 1;
                                
                            }
                        }
                    }
                    
                    self.page += 1;
                    self.outputValues()
                    
                } else {
                    
                    // done
                
                    let numberFormatter = NSNumberFormatter()
                    numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
                    
                    self.label_revenue.text = String("$\(numberFormatter.stringFromNumber(self.total_order_revenue)!)")
                    self.label_keyboards.text = String("\(self.num_keyboard)")
                    
                    print(self.total_order_revenue)
                    print(self.num_keyboard);
                    
                }
            }
        }
        
        task.resume()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        outputValues()
        
    }override func layoutSublayersOfLayer(layer: CALayer) {
        <#code#>
    }
}


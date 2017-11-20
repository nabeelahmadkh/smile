//
//  PhoneViewController.swift
//  smile
//
//  Created by Nabeel Ahmad Khan on 11/20/17.
//  Copyright © 2017 Defcon. All rights reserved.
//

import Foundation
import UIKit

class PhoneViewController: UIViewController{
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBAction func callHelpline(_ sender: Any) {
        let number = "+13194008304"
        
        let formattedNumber = number.components(separatedBy:
            NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        
        let phoneUrl = "tel://\(formattedNumber)"
        let url:NSURL = NSURL(string: phoneUrl)!
        print("URLS IS \(url)")
        
        if #available(iOS 10, *) {
            print("ENTERED IF CASE")
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        } else {
            print("ENTERED ELSE CASE")
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    
    override func viewDidLoad() {
        textLabel = ComponentFormatter().setLabel(textLabel, 18, UIColor.black)
        self.title = "HelpLine"
    }
}

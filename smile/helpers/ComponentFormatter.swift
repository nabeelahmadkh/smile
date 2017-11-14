//
//  ComponentFormatter.swift
//  smile
//
//  Created by Nabeel Ahmad Khan on 12/11/17.
//  Copyright © 2017 Defcon. All rights reserved.
//

import Foundation
import UIKit

// Helper class for Formatting
class ComponentFormatter {
    // Font and Color Setting for a Label
    func setLabel(_ label:UILabel, _ size:Int, _ color:UIColor) -> UILabel{
        let fontSize = CGFloat(size)
        label.font = UIFont(name: "ChalkboardSE-Bold", size: fontSize)
        label.textColor = color
        
        return label
    }
    
    // Font, TextColor and PlaceHolder Setting for a UITextField
    func setLabel(_ textField:UITextField, _ size: Int, _ color:UIColor, _ placeholderColor:UIColor, _ textLabel:String) -> UITextField{
        let fontSize = CGFloat(size)
        textField.font = UIFont(name: "ChalkboardSE-Bold", size: fontSize)
        textField.textColor = color
        textField.attributedPlaceholder = NSAttributedString(string: textLabel, attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        
        return textField
    }
    
    // Font, TextColor and PlaceHolder Setting for a LeftPaddedTextField
    func setLabel(_ textField:LeftPaddedTextField, _ size: Int, _ color:UIColor, _ placeholderColor:UIColor, _ textLabel:String) -> LeftPaddedTextField{
        let fontSize = CGFloat(size)
        textField.font = UIFont(name: "ChalkboardSE-Bold", size: fontSize)
        textField.textColor = color
        textField.attributedPlaceholder = NSAttributedString(string: textLabel, attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        
        return textField
    }
    
    // Font, TextColor and PlaceHolder Setting for a LeftPaddedTextField2
    func setLabel(_ textField:LeftPaddedTextField2, _ size: Int, _ color:UIColor, _ placeholderColor:UIColor, _ textLabel:String) -> LeftPaddedTextField2{
        let fontSize = CGFloat(size)
        textField.font = UIFont(name: "ChalkboardSE-Bold", size: fontSize)
        textField.textColor = color
        textField.attributedPlaceholder = NSAttributedString(string: textLabel, attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        
        return textField
    }
    
    // Size, Font and Color of a Button
    func setButton(_ button:UIButton, _ size: Int, _ color:UIColor) -> UIButton{
        let fontSize = CGFloat(size)
        button.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: fontSize)
        button.setTitleColor(color, for: .normal)
        
        return button
    }
}

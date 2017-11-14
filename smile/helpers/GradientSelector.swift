//
//  GradientSelector.swift
//  
//
//  Created by Nabeel Ahmad Khan on 13/11/17.
//

import UIKit

class GradientSelector {
    var gradientLayer:CAGradientLayer!
    
    func setGradient(view:UIView, type:Int) -> UIView{
        gradientLayer = CAGradientLayer();
        gradientLayer.frame = view.bounds
        switch type {
        case 0:
            gradientLayer.colors = [UIColor.init(red: 241/256, green: 181/256, blue: 54/256, alpha: 1).cgColor, UIColor.yellow.cgColor, UIColor.init(red: 241/256, green: 181/256, blue: 54/256, alpha: 1).cgColor]
        case 1:
            gradientLayer.colors = [UIColor.gray.cgColor, UIColor.white.cgColor, UIColor.gray.cgColor, UIColor.black.cgColor]
        case 2:
            gradientLayer.colors = [UIColor.black.cgColor, UIColor.gray.cgColor, UIColor.white.cgColor, UIColor.gray.cgColor, UIColor.black.cgColor]
        case 3:
            gradientLayer.colors = [UIColor.init(red: 241, green: 181, blue: 54, alpha: 1).cgColor, UIColor.yellow.cgColor, UIColor.init(red: 241, green: 181, blue: 54, alpha: 1).cgColor]
        default:
            gradientLayer.colors = [UIColor.gray.cgColor, UIColor.white.cgColor, UIColor.gray.cgColor]
        }
        view.layer.insertSublayer(gradientLayer, at: 0)
        return view
    }
    
    func setGradientScrollView(view:UIScrollView, type:Int) -> UIScrollView{
        gradientLayer = CAGradientLayer();
        gradientLayer.frame = view.bounds
        switch type {
        case 0:
            gradientLayer.colors = [UIColor.init(red: 241/256, green: 181/256, blue: 54/256, alpha: 1).cgColor, UIColor.yellow.cgColor, UIColor.init(red: 241/256, green: 181/256, blue: 54/256, alpha: 1).cgColor]
        default:
            gradientLayer.colors = [UIColor.gray.cgColor, UIColor.white.cgColor, UIColor.gray.cgColor]
        }
        view.layer.insertSublayer(gradientLayer, at: 0)
        return view
    }
}


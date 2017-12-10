//
//  GradientSelector.swift
//  
//
//  Created by Nabeel Ahmad Khan on 13/11/17.
//

/*
 
 linear-gradient(to right, rgba(32,124,229,1) 0%, rgba(32,124,229,1) 9%, rgba(174,211,245,1) 35%, rgba(115,174,230,1) 60%, rgba(6,87,163,1) 88%, rgba(6,87,163,1) 100%);
 linear-gradient(to right, rgba(255,124,216,1) 0%, rgba(255,124,216,1) 7%, rgba(250,203,236,1) 33%, rgba(245,164,219,1) 59%, rgba(235,80,194,1) 90%, rgba(235,80,194,1) 100%);
 linear-gradient(to right, rgba(158,155,245,1) 0%, rgba(158,155,245,1) 8%, rgba(235,233,249,1) 35%, rgba(206,199,236,1) 62%, rgba(141,106,245,1) 93%, rgba(141,106,245,1) 100%);
 */


import UIKit

class GradientSelector {
    var gradientLayer:CAGradientLayer!
    
    func setGradient(view:UIView, type:String) -> UIView{
        gradientLayer = CAGradientLayer();
        gradientLayer.frame = view.bounds
        switch type {
        case "male":
            gradientLayer.colors = [UIColor.init(red: 32/256, green: 124/256, blue: 229/256, alpha: 1).cgColor, UIColor.init(red: 32/256, green: 124/256, blue: 229/256, alpha: 1).cgColor, UIColor.init(red: 174/256, green: 211/256, blue: 245/256, alpha: 1).cgColor, UIColor.init(red: 115/256, green: 174/256, blue: 230/256, alpha: 1).cgColor, UIColor.init(red: 6/256, green: 87/256, blue: 163/256, alpha: 1).cgColor, UIColor.init(red: 6/256, green: 87/256, blue: 163/256, alpha: 1).cgColor]
        case "female":
            gradientLayer.colors = [UIColor.init(red: 255/256, green: 124/256, blue: 216/256, alpha: 1).cgColor, UIColor.init(red: 255/256, green: 124/256, blue: 216/256, alpha: 1).cgColor, UIColor.init(red: 250/256, green: 203/256, blue: 236/256, alpha: 1).cgColor, UIColor.init(red: 250/256, green: 164/256, blue: 219/256, alpha: 1).cgColor, UIColor.init(red: 235/256, green: 80/256, blue: 194/256, alpha: 1).cgColor, UIColor.init(red: 235/256, green: 80/256, blue: 194/256, alpha: 1).cgColor]
        case "other":
            gradientLayer.colors = [UIColor.init(red: 158/256, green: 155/256, blue: 245/256, alpha: 1).cgColor, UIColor.init(red: 158/256, green: 155/256, blue: 245/256, alpha: 1).cgColor, UIColor.init(red: 235/256, green: 233/256, blue: 249/256, alpha: 1).cgColor, UIColor.init(red: 206/256, green: 199/256, blue: 236/256, alpha: 1).cgColor, UIColor.init(red: 141/256, green: 106/256, blue: 245/256, alpha: 1).cgColor, UIColor.init(red: 141/256, green: 106/256, blue: 245/256, alpha: 1).cgColor]
        default:
            gradientLayer.colors = [UIColor.init(red: 32/256, green: 124/256, blue: 229/256, alpha: 1).cgColor, UIColor.init(red: 32/256, green: 124/256, blue: 229/256, alpha: 1).cgColor, UIColor.init(red: 174/256, green: 211/256, blue: 245/256, alpha: 1).cgColor, UIColor.init(red: 115/256, green: 174/256, blue: 230/256, alpha: 1).cgColor, UIColor.init(red: 6/256, green: 87/256, blue: 163/256, alpha: 1).cgColor, UIColor.init(red: 6/256, green: 87/256, blue: 163/256, alpha: 1).cgColor]
        }
        view.layer.insertSublayer(gradientLayer, at: 0)
        return view
    }
    
    func setGradientScrollView(view:UIScrollView, type:String) -> UIScrollView{
        gradientLayer = CAGradientLayer();
        gradientLayer.frame = view.bounds
        switch type {
        case "male":
            gradientLayer.colors = [UIColor.init(red: 32/256, green: 124/256, blue: 229/256, alpha: 1).cgColor, UIColor.init(red: 32/256, green: 124/256, blue: 229/256, alpha: 1).cgColor, UIColor.init(red: 174/256, green: 211/256, blue: 245/256, alpha: 1).cgColor, UIColor.init(red: 115/256, green: 174/256, blue: 230/256, alpha: 1).cgColor, UIColor.init(red: 6/256, green: 87/256, blue: 163/256, alpha: 1).cgColor, UIColor.init(red: 6/256, green: 87/256, blue: 163/256, alpha: 1).cgColor]
        case "female":
            gradientLayer.colors = [UIColor.init(red: 255/256, green: 124/256, blue: 216/256, alpha: 1).cgColor, UIColor.init(red: 255/256, green: 124/256, blue: 216/256, alpha: 1).cgColor, UIColor.init(red: 250/256, green: 203/256, blue: 236/256, alpha: 1).cgColor, UIColor.init(red: 250/256, green: 164/256, blue: 219/256, alpha: 1).cgColor, UIColor.init(red: 235/256, green: 80/256, blue: 194/256, alpha: 1).cgColor, UIColor.init(red: 235/256, green: 80/256, blue: 194/256, alpha: 1).cgColor]
        case "other":
            gradientLayer.colors = [UIColor.init(red: 158/256, green: 155/256, blue: 245/256, alpha: 1).cgColor, UIColor.init(red: 158/256, green: 155/256, blue: 245/256, alpha: 1).cgColor, UIColor.init(red: 235/256, green: 233/256, blue: 249/256, alpha: 1).cgColor, UIColor.init(red: 206/256, green: 199/256, blue: 236/256, alpha: 1).cgColor, UIColor.init(red: 141/256, green: 106/256, blue: 245/256, alpha: 1).cgColor, UIColor.init(red: 141/256, green: 106/256, blue: 245/256, alpha: 1).cgColor]
        default:
            gradientLayer.colors = [UIColor.init(red: 32/256, green: 124/256, blue: 229/256, alpha: 1).cgColor, UIColor.init(red: 32/256, green: 124/256, blue: 229/256, alpha: 1).cgColor, UIColor.init(red: 174/256, green: 211/256, blue: 245/256, alpha: 1).cgColor, UIColor.init(red: 115/256, green: 174/256, blue: 230/256, alpha: 1).cgColor, UIColor.init(red: 6/256, green: 87/256, blue: 163/256, alpha: 1).cgColor, UIColor.init(red: 6/256, green: 87/256, blue: 163/256, alpha: 1).cgColor]
        }
        view.layer.insertSublayer(gradientLayer, at: 0)
        return view
    }
}


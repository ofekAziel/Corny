//
//  SignUpViewController.swift
//  Corny
//
//  Created by ofek aziel on 16/01/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static var aView: UIView!
    static var spinner: UIActivityIndicatorView!
    
    static func styleTextField(_ textfield:UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.black.cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
    }
    
    static func styleTextView(_ textView:UITextView) {
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.black.cgColor
    }
    
    static func styleFilledButton(_ button:UIButton) {
        button.backgroundColor = UIColor.init(red: 255/255, green: 127/255, blue: 80/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func makeSpinner(view: UIView) {
        aView = UIView(frame: view.bounds)
        aView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        spinner = UIActivityIndicatorView(style: .large)
        spinner.center = aView.center
        spinner.startAnimating()
        aView.addSubview(spinner)
        view.addSubview(aView)
    }
    
    static func removeSpinner() {
        aView.removeFromSuperview()
        aView = nil
    }
    
    static func showError(_ message:String, errorLabel: UILabel) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}

//
//  LoginViewController.swift
//  Corny
//
//  Created by ofek aziel on 16/01/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
         setUpElements()
    }
    
    func setUpElements() {
           errorLabel.alpha = 0
           Utilities.styleTextField(emailTextField)
           Utilities.styleTextField(passwordTextField)
           Utilities.styleFilledButton(loginButton)
       }
    
    @IBAction func loginTapped(_ sender: Any) {
        let error = validateFields()
          
          if error != nil {
            Utilities.showError(error!, errorLabel: errorLabel)
          } else {
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            signIn(email: email, password: password)
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
              if error != nil {
                Utilities.showError(error!.localizedDescription, errorLabel: self.errorLabel)
              } else {
                  self.transitionToMovieScreen()
              }
          }
    }
    
    func transitionToMovieScreen() {
        var cornyStoryboard: UIStoryboard!
        cornyStoryboard = UIStoryboard(name: Constants.Storyboard.cornyStroyBoard, bundle: nil)
        guard let cornyNavigationController = cornyStoryboard.instantiateViewController(identifier: Constants.Storyboard.cornyNavigationController) as? UINavigationController else {
            return
        }
        
        view.window?.rootViewController = cornyNavigationController
        view.window?.makeKeyAndVisible()
    }
    
    func validateFields() -> String? {
        if isTextFieldsEmpty() {
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    func isTextFieldsEmpty() -> Bool {
        return emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
}

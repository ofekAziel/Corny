//
//  SignUpViewController.swift
//  Corny
//
//  Created by ofek aziel on 16/01/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        } else {
            let firstName = firstNameTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            createUser(firstName: firstName, lastName: lastName, email: email, password: password)
            self.transitionToMovieScreen()
        }
    }
    
    func createUser(firstName: String, lastName: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if err != nil {
                self.showError("Error creating user.")
            } else {
                let db = Firestore.firestore()
                
                db.collection("users").addDocument(data: ["uid": result!.user.uid, "first_name": firstName, "last_name": lastName, "is_admin": false]) { (error) in
                    
                    if error != nil {
                        self.showError("Error saving user data.")
                    }
                }
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
        
        let cleanedPassword =
            passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            return "Please make sure your password is at least 8 characters, contains a speacial character and a number."
        }
        
        return nil
    }
    
    func isTextFieldsEmpty() -> Bool {
        return firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}

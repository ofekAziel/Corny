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
//        MovieDB.deleteAllMovies(database: DBHelper.instance.db)
//        UserDB.deleteAllUsers(database: DBHelper.instance.db) USE JUST IF YOU WANT TO CLEAR ALL ROWS
//        CommentDB.deleteAllComments(database: DBHelper.instance.db)
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
            Utilities.showError(error!, errorLabel: errorLabel)
        } else {
            let firstName = firstNameTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Utilities.makeSpinner(view: self.view)
            createUser(firstName: firstName, lastName: lastName, email: email, password: password)
        }
    }
    
    func createUser(firstName:String, lastName:String, email:String, password:String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if err != nil {
                Utilities.showError("Error creating user.", errorLabel: self.errorLabel)
            } else {
                let usersRef = Firestore.firestore().collection(Constants.Firestore.usersCollection).document()
                let userData = ["user_uid":result!.user.uid, "first_name":firstName, "last_name":lastName, "is_admin":false] as [String : Any]
                
                usersRef.setData(userData) { (err) in
                    if err != nil {
                        Utilities.showError("Can't save this movie.", errorLabel: self.errorLabel)
                    } else {
                        let user = User(id: usersRef.documentID, firstName: firstName, lastName: lastName, isAdmin: false, userUid: result!.user.uid)
                        UserDB.addOrUpdateUserToDb(user: user, database: DBHelper.instance.db)
                        Utilities.removeSpinner()
                        self.transitionToMovieScreen()
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
}

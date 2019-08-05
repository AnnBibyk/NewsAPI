//
//  RegistrationViewController.swift
//  News
//
//  Created by Anna Bibyk on 8/1/19.
//  Copyright © 2019 Anna Bibyk. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @IBAction func registerButtonPressed(_ sender: Any) {
        guard emailTextField.text != "", passwordTextField.text != "", passwordConfirmationTextField.text != "" else { return }
        
        if passwordTextField.text == passwordConfirmationTextField.text {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    print("\nError occured in registration\n")
                    print(error!)
                    
                    let alert = UIAlertController(title: "Registration Failed",
                                                  message: error?.localizedDescription,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    print("\nRegistration Successful\n")
                    
                    let ref = Database.database().reference().child("Users")
                    ref.child(user!.user.uid).updateChildValues(["email" : self.emailTextField.text!])
                    
                    self.performSegue(withIdentifier: "goToUserInfo", sender: self)

                }
            }
        }else {
            print("\nPasswords do not match!\n")
            
            let alert = UIAlertController(title: "Registration Failed",
                                          message: "Passwords do not match",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

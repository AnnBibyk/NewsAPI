//
//  LogInViewController.swift
//  News
//
//  Created by Anna Bibyk on 8/1/19.
//  Copyright © 2019 Anna Bibyk. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print("\nError occured when logging in\n")
                print(error!)
                
                let alert = UIAlertController(title: "Log In Failed",
                                              message: error?.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                print("\nLog in Successful\n")
                
                self.performSegue(withIdentifier: "goToMainScreen", sender: self)
                self.emailTextField.text = nil
                self.passwordTextField.text = nil
            }
        }
    }
    

}

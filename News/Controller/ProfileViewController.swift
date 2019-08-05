//
//  ProfileViewController.swift
//  News
//
//  Created by Anna Bibyk on 8/2/19.
//  Copyright © 2019 Anna Bibyk. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITextFieldDelegate {

    let userDB = Database.database().reference().child("userProfile")
    
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var mobileLabel: UITextField!
    @IBOutlet weak var cityNameLabel: UITextField!
    @IBOutlet weak var newPaswordLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mobileLabel.delegate = self
        
        retriveUserData()
    }
    
    // MARK: - Fetching user info from database
    
    func retriveUserData() {
        
        let uid = Auth.auth().currentUser?.uid
        _ = Database.database().reference().child("Users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Dictionary<String, String> {
                let firstName = value["FirstName"]!
                let lastName = value["LastName"]!
                let mobile = value["Mobile"]!
                let city = value["City"]!
                
                self.firstNameLabel.text = firstName
                self.lastNameLabel.text = lastName
                self.mobileLabel.text = mobile
                self.cityNameLabel.text = city
            }
        }
    }

    // MARK: - Updating user info
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard firstNameLabel.text != "", lastNameLabel.text != "", mobileLabel.text != "", cityNameLabel.text != "" else {
            let alert = UIAlertController(title: "Ooops!",
                                          message: "All fields must be filled",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("Users").child("\(uid)")
        
        let userProfileDic = ["FirstName": firstNameLabel.text!,
                              "LastName": lastNameLabel.text!,
                              "Mobile": mobileLabel.text!,
                              "City": cityNameLabel.text!]
        let childUpdates = userProfileDic
        ref.updateChildValues(childUpdates)
        print("Saved")
        
        let alert = UIAlertController(title: "Profile updating",
                                      message: "Your profile has been successfully updated",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Updating password
    
    @IBAction func changePasswordPressed(_ sender: Any) {
        guard newPaswordLabel.text != "" else {
            
            let alert = UIAlertController(title: "Ooops!",
                                          message: "You haven't entered a new password",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let user = Auth.auth().currentUser
        user?.updatePassword(to: newPaswordLabel.text!, completion: { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let alert = UIAlertController(title: "Password updating",
                                              message: "Your password has been successfully updated",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
                print("Password Updated")
            }
        })
    }
    
    // MARK: - For mobile numer validation
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileLabel {
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789 ")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
}

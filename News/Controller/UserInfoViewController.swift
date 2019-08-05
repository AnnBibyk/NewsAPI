//
//  UserInfoViewController.swift
//  News
//
//  Created by Anna Bibyk on 8/1/19.
//  Copyright © 2019 Anna Bibyk. All rights reserved.
//

import UIKit
import Firebase

class UserInfoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userSurnameTextField: UITextField!
    @IBOutlet weak var userMobileTextField: UITextField!
    @IBOutlet weak var userCityTextField: UITextField!
    @IBOutlet weak var dateOfBirthPicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userMobileTextField.delegate = self

        // MARK: - Setting the dates for dateOfBirthPicker
        
        let calendar = Calendar(identifier: .gregorian)
        
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        
        components.year = -18
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        
        components.year = -150
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        
        dateOfBirthPicker.minimumDate = minDate
        dateOfBirthPicker.maximumDate = maxDate
    }
   
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard userNameTextField.text != "", userSurnameTextField.text != "", userMobileTextField.text != "", userCityTextField.text != "" else {
            let alert = UIAlertController(title: "Ooops!",
                                          message: "All fields must be filled",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let format = DateFormatter()
        format.dateFormat = "dd MMMM yyyy"
        let date = format.string(from: dateOfBirthPicker.date)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("Users").child("\(uid)")
        
        let userProfileDic = ["FirstName" : userNameTextField.text!,
                            "LastName" : userSurnameTextField.text!,
                            "Mobile" : userMobileTextField.text!,
                            "City" : userCityTextField.text!,
                                "DateOfBirth" : date]
        
        let childUpdates = userProfileDic
        
        ref.updateChildValues(childUpdates)
        performSegue(withIdentifier: "goToSources", sender: self)
    }
    
    // MARK: - For mobile numer validation
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == userMobileTextField {
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789 ")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}

//
//  SideMenuViewController.swift
//  News
//
//  Created by Anna Bibyk on 8/2/19.
//  Copyright © 2019 Anna Bibyk. All rights reserved.
//

import UIKit
import Firebase
import SideMenu

class SideMenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            dismiss(animated: true, completion: nil)
        } else if indexPath.row == 4 {
            try! Auth.auth().signOut()
            print("Log out")
            if let storyboard = self.storyboard {
                let vc = storyboard.instantiateViewController(withIdentifier: "firstNavigationController") as! UINavigationController
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

}

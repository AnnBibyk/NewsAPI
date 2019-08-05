//
//  SourceScreenTableViewController.swift
//  News
//
//  Created by Anna Bibyk on 8/2/19.
//  Copyright © 2019 Anna Bibyk. All rights reserved.
//

import UIKit
import Firebase

class SourceScreenTableViewController: UITableViewController {

    var sourceArray : SourceData?
    var selectedSourcesArray = [String]()
    var selectedSources = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let SaveButton = UIBarButtonItem(image: UIImage(named: "save-3"), style: .plain, target: self, action: #selector(saveButtonPressed))
        self.navigationItem.rightBarButtonItem = SaveButton
    
        NewsAPI.requestSourcesData(complitionHandler: handlerDownload(sourceArray:error:))
    }

    func handlerDownload(sourceArray : SourceData?, error : Error?)
    {
        if sourceArray?.sources.isEmpty == false {
            DispatchQueue.main.async {
                self.sourceArray = sourceArray!
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func saveButtonPressed() {
        guard selectedSources.count != 0 else {
            let alert = UIAlertController(title: "Ooops",
                                          message: "You have to choose at least 1 source",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("Users").child("\(uid)")
        
        let userProfileDic = ["chosenSources" : selectedSources]

        let childUpdates = userProfileDic
        
        ref.updateChildValues(childUpdates)
        
        self.performSegue(withIdentifier: "goToMainScreen", sender: self)
        
        print(selectedSources)
        print("Sources saved")
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceArray?.sources.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sourceCell", for: indexPath) as! SourceCell

        cell.sourceNameLabel.text = sourceArray?.sources[indexPath.row].name
        
        let switchObj = UISwitch(frame: CGRect(x: 1, y: 1, width: 20, height: 20))
        switchObj.isOn = false
        switchObj.tag = indexPath.row
        switchObj.addTarget(self, action: #selector(toggle(_:)), for: .valueChanged)
        cell.accessoryView = switchObj
        
        return cell
    }
    
    @objc func toggle(_ sender: UISwitch) {
        guard let item = sourceArray?.sources[sender.tag].id else { return }
        
        if sender.isOn {
            selectedSourcesArray.append(item)
        } else {
            selectedSourcesArray = selectedSourcesArray.filter {$0 != item}
        }
        selectedSources = selectedSourcesArray.joined(separator: ",")
    }

}

//
//  MainScreenTableViewController.swift
//  News
//
//  Created by Anna Bibyk on 8/1/19.
//  Copyright © 2019 Anna Bibyk. All rights reserved.
//

import UIKit
import Firebase

class MainScreenTableViewController: UITableViewController {

    var newsArray : NewsData?
    var source : String = ""
    
    var refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retriveSources()
        self.refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.tableView.addSubview(refresh)
    }

    @objc func handleRefresh() {
        NewsAPI.requestArticlesData(source: source, complitionHandler: handlerDownload(newsArray:error:))
        refresh.endRefreshing()
        print("\nRefresh\n")
    }
    
    func handlerDownload(newsArray : NewsData?, error : Error?)
    {
        if newsArray?.articles.isEmpty == false {
            DispatchQueue.main.async {
                self.newsArray = newsArray!
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Updating user info
    
    func retriveSources() {
        let uid = Auth.auth().currentUser?.uid
        _ = Database.database().reference().child("Users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Dictionary<String, String> {
                self.source = value["chosenSources"] ?? "bbc-news"
                NewsAPI.requestArticlesData(source: self.source, complitionHandler: self.handlerDownload(newsArray:error:))
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray?.articles.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
        cell.articleTitleLabel.text = newsArray?.articles[indexPath.row].title
        cell.articleAuthorLabel.text = newsArray?.articles[indexPath.row].source.name
        cell.descriptionLabel.text = newsArray?.articles[indexPath.row].articleDescription
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! ArticleViewController
        
        webVC.url = newsArray?.articles[indexPath.row].url
        print(webVC.url!)
        
        self.present(webVC, animated: true, completion: nil)
    }
}

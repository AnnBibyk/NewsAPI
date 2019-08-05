//
//  ArticleViewController.swift
//  News
//
//  Created by Anna Bibyk on 8/2/19.
//  Copyright © 2019 Anna Bibyk. All rights reserved.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController {

    var url: String?
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: URL(string: url!)!))
    }
    
    
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

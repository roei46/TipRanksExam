//
//  WebViewController.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 24/07/2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webViewer: WKWebView!
    
    var link = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        webViewer.navigationDelegate = self
        let url = URL(string: link)!
        webViewer.load(URLRequest(url: url))
        webViewer.allowsBackForwardNavigationGestures = true
    }
}

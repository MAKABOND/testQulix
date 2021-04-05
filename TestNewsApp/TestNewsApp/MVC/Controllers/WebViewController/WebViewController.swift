//
//  WebViewController.swift
//  TestNewsApp
//
//  Created by пользователь on 4/3/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    // MARK: - Declaration
    @IBOutlet weak var webView: WKWebView!
    private var stringUrl: String?
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        if let stringUrl = stringUrl {
            let url = URL(string: stringUrl)!
            webView.load(URLRequest(url: url))
        }
    }
    
    // MARK: - Initialization
    convenience init (urlString: String) {
        self.init()
        stringUrl = urlString
    }
    
}

// MARK: - Extension
extension WebViewController: WKNavigationDelegate {
    
}

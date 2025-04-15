//
//  WebViewController.swift
//  Vibe
//
//  Created by Siddharth Lamba on 2025-04-14.
//


import UIKit
import WebKit

class WebViewController: UIViewController {

    var webView: WKWebView!
    var urlString: String?

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Event Link"

        guard let urlString = urlString, let url = URL(string: urlString) else {
            let label = UILabel()
            label.text = "Invalid URL"
            label.textAlignment = .center
            view.addSubview(label)
            label.frame = view.bounds
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @IBAction func openEventLinkTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let webVC = storyboard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
            webVC.urlString = "https://amanpurohit.com" // or event.link
            navigationController?.pushViewController(webVC, animated: true)
        }
    }

}

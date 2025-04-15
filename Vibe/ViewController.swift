//
//  ViewController.swift
//  Vibe
//
//  Created by Aman Purohit on 2025-03-26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func openEventLinkTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let webVC = storyboard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
            webVC.urlString = "https://amanpurohit.com" // or event.link
            navigationController?.pushViewController(webVC, animated: true)
        }
    }


}


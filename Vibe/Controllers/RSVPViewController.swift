//
//  RSVPViewController.swift
//  Vibe
//
//  Created by Aman Purohit on 2025-03-26.
//

//import UIKit
//
//class RSVPViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//    @IBAction func rsvpTapped(_ sender: UIButton) {
//        // Save RSVP to Firestore or your DB...
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let confirmVC = storyboard.instantiateViewController(withIdentifier: "RSVPConfirmationViewController") as? RSVPConfirmationViewController {
//            confirmVC.eventID = "event_abc123"
//            confirmVC.eventTitle = "Hackville 2025"
//            confirmVC.eventDate = "April 20, 2025"
//            self.navigationController?.pushViewController(confirmVC, animated: true)
//        }
//    }
//
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
import UIKit

class RSVPController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func rsvpTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let confirmVC = storyboard.instantiateViewController(withIdentifier: "RSVPConfirmationViewController") as? RSVPConfirmationViewController {
            confirmVC.eventID = "event_001"
            confirmVC.eventTitle = "Coffee Chat with Developers"
            confirmVC.eventDate = "April 14, 2025"
//            self.navigationController?.pushViewController(confirmVC, animated: true)
            self.present(confirmVC, animated: true)

        }
    }
}

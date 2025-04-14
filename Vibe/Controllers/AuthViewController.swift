//
//  AuthViewController.swift
//  Vibe
//
//  Created by Aman Purohit on 2025-03-26.
//

//import UIKit
//import Firebase
//
//class AuthViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("Is Firebase working? \(FirebaseApp.app() != nil)")
//        // Do any additional setup after loading the view.
//    }
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
import FirebaseAuth

class AuthController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(title: "Login Failed", message: error.localizedDescription)
            } else {
//                self.showAlert(title: "Success", message: "Logged in as \(authResult?.user.email ?? "")")
                self.dismiss(animated: true, completion: nil)
                // Navigate to dashboard or next screen
            }
        }
    }

    @IBAction func registerTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(title: "Registration Failed", message: error.localizedDescription)
            } else {
                self.showAlert(title: "Success", message: "Registered as \(authResult?.user.email ?? "")")
                // Optionally auto-login or go to next screen
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

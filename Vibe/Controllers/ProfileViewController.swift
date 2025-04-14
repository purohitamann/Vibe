//
//  ProfileViewController.swift
//  Vibe
//
//  Created by Aman Purohit on 2025-03-26.
//

//import UIKit
//
//class ProfileViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
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
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserProfile()
    }
    
    func loadUserProfile() {
        guard let user = Auth.auth().currentUser else { return }

        emailLabel.text = user.email

        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { document, error in
            if let doc = document, doc.exists {
                self.nameTextField.text = doc["name"] as? String
                
                if let profilePicURL = doc["profilePic"] as? String,
                   let url = URL(string: profilePicURL) {
                    URLSession.shared.dataTask(with: url) { data, _, _ in
                        if let data = data {
                            DispatchQueue.main.async {
                                self.profileImageView.image = UIImage(data: data)
                            }
                        }
                    }.resume()
                }
            }
        }
    }

    @IBAction func editProfileTapped(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser,
              let name = nameTextField.text else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).setData([
            "name": name,
            "email": user.email ?? ""
        ], merge: true) { error in
            if let error = error {
                self.showAlert("Error updating profile: \(error.localizedDescription)")
            } else {
                self.showAlert("Profile updated!")
            }
        }
    }

    
    @IBAction func uploadPictureTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        try? Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil) // or navigate to login
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage,
              let data = image.jpegData(compressionQuality: 0.8),
              let uid = Auth.auth().currentUser?.uid else { return }

        profileImageView.image = image
        
        let storageRef = Storage.storage().reference().child("profileImages/\(uid).jpg")
        storageRef.putData(data, metadata: nil) { _, error in
            if let error = error {
                self.showAlert("Upload failed: \(error.localizedDescription)")
            } else {
                storageRef.downloadURL { url, error in
                    if let downloadURL = url {
                        // Save URL to Firestore
                        let db = Firestore.firestore()
                        db.collection("users").document(uid).setData([
                            "profilePic": downloadURL.absoluteString
                        ], merge: true)
                        self.showAlert("Profile picture updated!")
                    }
                }
            }
        }
    }


    func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


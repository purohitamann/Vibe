//
//  CreateEventViewController.swift
//  Vibe
//
//  Created by Reshmi Patel on 14/04/25.
//
import UIKit
import FirebaseFirestore
//import FirebaseAuth
class CreateEventViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
      
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 6
       
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text,
              let location = locationTextField.text,
              !title.isEmpty, !location.isEmpty else {
            showAlert(message: "Please fill in required fields.")
            return
        }

        let event = Event(
            id: UUID().uuidString,
            title: title,
            date: datePicker.date,
            location: location,
            description: descriptionTextView.text ?? ""
        )

        let db = Firestore.firestore()
        db.collection("events").addDocument(data: event.toDictionary()) { error in
            if let error = error {
                print("Error saving event: \(error)")
                self.showAlert(message: "Failed to save event.")
            } else {
                print("Event saved successfully!")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
   

}

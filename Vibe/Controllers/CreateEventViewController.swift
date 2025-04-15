//
//  CreateEventViewController.swift
//  Vibe
//
//  Created by Reshmi Patel.
//
//  This view controller allows the user to create a new event by entering in
//  fields and saving data to Firestore.
import UIKit
import FirebaseFirestore
//import FirebaseAuth
class CreateEventViewController: UIViewController {
    //Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    // After the view has been loaded into memory, this is called
    override func viewDidLoad() {
        super.viewDidLoad()
      // UI for description box
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 6
       
    }
 // Validates input fields and stores new event data in Firestore. Works when the save button is tapped.
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // ensures title and location are provided
        guard let title = titleTextField.text,
              let location = locationTextField.text,
              !title.isEmpty, !location.isEmpty else {
            showAlert(message: "Please fill in required fields.")
            return
        }
    // Creating a new Event object with unique ID and form data
        let event = Event(
            id: UUID().uuidString,
            title: title,
            date: datePicker.date,
            location: location,
            description: descriptionTextView.text ?? ""
        )
        // Save the event data in "events" in firebase
        let db = Firestore.firestore()
        db.collection("events").addDocument(data: event.toDictionary()) { error in
            if let error = error {
                //this  will show alert if it fails
                print("Error saving event: \(error)")
                self.showAlert(message: "Failed to save event.")
            } else {
                 // after successful save will take us back
                print("Event saved successfully!")

                // Go back to event list 
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }

    }
    //alert box with custom message to show user about error and input validation
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
   

}

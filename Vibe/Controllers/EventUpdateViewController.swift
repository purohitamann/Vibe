//
//  EventUpdateViewController.swift
//  Vibe
//
//  Created by Reshmi Patel on 14/04/25.
// In this Controller, event data can be updated and deleted by the user. 

import UIKit
import FirebaseFirestore

class EventUpdateViewController: UIViewController {
   //Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
//Array of events fetched from database
    var event: Event?
// this will be called after view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        //will set border style
        setupUI()
      //UI will be updated based on fetched data
        loadEventData()
    }
//Using this to apply stylying to textview
    func setupUI() {
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        descriptionTextView.layer.cornerRadius = 6
    }
//when event is selected this fill the UI with the data
    func loadEventData() {
        guard let event = event else { return }

        titleTextField.text = event.title
        datePicker.date = event.date
        locationTextField.text = event.location
        descriptionTextView.text = event.description
    }
    //when update button is tapped ,this will validate input fields
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        guard let event = event,
              let title = titleTextField.text,
              let location = locationTextField.text,
              !title.isEmpty, !location.isEmpty else {
            showAlert(message: "Please fill in all required fields.")
            return

        }
    // will update the directory in firebase with updated data
        let updatedData: [String: Any] = [
            "title": title,
            "date": Timestamp(date: datePicker.date),
            "location": location,
            "description": descriptionTextView.text ?? ""
        ]
    //event document will get updated in firebase
        let db = Firestore.firestore()
        db.collection("events").document(event.id).updateData(updatedData) { error in
            if let error = error {
                print("Error updating event: \(error)")
                self.showAlert(message: "Failed to update event.")
            } else {
                print("Event updated.")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
// action will be triggered when delete button is tapped
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        guard let eventId = event?.id else { return }
    //show confirmation and event will be deleted
        let db = Firestore.firestore()
        db.collection("events").document(eventId).delete { error in
            if let error = error {
                print("Error deleting event: \(error)")
                self.showAlert(message: "Failed to delete event.")
            } else {
                print("Event deleted.")
                self.navigationController?.popViewController(animated: true)
            }
        }
       
    }
    // shows alert with a message
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    // show confirmation alert after deletion
    func deleteEvent() {
            guard let eventId = event?.id else { return }

            let db = Firestore.firestore()
            db.collection("events").document(eventId).delete { error in
                if let error = error {
                    print("Error deleting event: \(error)")
                    self.showAlert(message: "Failed to delete event.")
                } else {
                    self.showAlertAndPop(message: "Event deleted successfully.")
                }
            }
        }

       
    // action with alert to return to previous screen
        func showAlertAndPop(message: String) {
            let alert = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true)
        }
}

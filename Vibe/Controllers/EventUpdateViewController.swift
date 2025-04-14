//
//  EventUpdateViewController.swift
//  Vibe
//
//  Created by Reshmi Patel on 14/04/25.
//

import UIKit
import FirebaseFirestore

class EventUpdateViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!

    var event: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
      
        loadEventData()
    }

    func setupUI() {
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        descriptionTextView.layer.cornerRadius = 6
    }

    func loadEventData() {
        guard let event = event else { return }

        titleTextField.text = event.title
        datePicker.date = event.date
        locationTextField.text = event.location
        descriptionTextView.text = event.description
    }

    @IBAction func updateButtonTapped(_ sender: UIButton) {
        guard let event = event,
              let title = titleTextField.text,
              let location = locationTextField.text,
              !title.isEmpty, !location.isEmpty else {
            showAlert(message: "Please fill in all required fields.")
            return

        }

        let updatedData: [String: Any] = [
            "title": title,
            "date": Timestamp(date: datePicker.date),
            "location": location,
            "description": descriptionTextView.text ?? ""
        ]

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

    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        guard let eventId = event?.id else { return }

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

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
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

        // MARK: - Helpers

        func showAlertAndPop(message: String) {
            let alert = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true)
        }
}

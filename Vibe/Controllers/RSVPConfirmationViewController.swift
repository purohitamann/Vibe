//
//  RSVPConfirmationViewController.swift
//  Vibe
//
//  Created by Aman Purohit on 2025-04-13.
//


import UIKit
import FirebaseAuth
import EventKit


class RSVPConfirmationViewController: UIViewController {

    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    var eventID: String = ""
    var eventTitle: String = ""
    var eventDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTitleLabel.text = eventTitle
        eventDateLabel.text = eventDate
        addEventToCalendar(title: eventTitle, dateString: eventDate)

        if let userID = Auth.auth().currentUser?.uid {
            let qrData = "\(eventID)|\(userID)"
            qrCodeImageView.image = generateQRCode(from: qrData)
        }
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: .ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("Q", forKey: "inputCorrectionLevel")

            if let outputImage = filter.outputImage {
                let scaleX = 200 / outputImage.extent.size.width
                let scaleY = 200 / outputImage.extent.size.height
                let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
                return UIImage(ciImage: transformedImage)
            }
        }
        return nil
    }
    func addEventToCalendar(title: String, dateString: String) {
        let eventStore = EKEventStore()

        // Request access
        eventStore.requestAccess(to: .event) { granted, error in
            if granted, error == nil {
                // Convert date string to Date object
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM dd, yyyy HH:mm" // Adjust based on your eventDate format
                guard let eventDate = formatter.date(from: dateString + " 10:00") else { return } // Default 10 AM

                // Create calendar event
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = eventDate
                event.endDate = eventDate.addingTimeInterval(60 * 60) // 1-hour duration
                event.calendar = eventStore.defaultCalendarForNewEvents

                do {
                    try eventStore.save(event, span: .thisEvent)
                    print("✅ Event added to calendar!")
                } catch {
                    print("❌ Failed to save event: \(error.localizedDescription)")
                }
            } else {
                print("❌ Calendar access denied or error: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }

}

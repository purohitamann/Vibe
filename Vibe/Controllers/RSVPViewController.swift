import UIKit
import FirebaseFirestore
import FirebaseAuth

class RSVPController: UIViewController {

    var event: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func rsvpTapped(_ sender: UIButton) {
        guard let event = event,
              let uid = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(event.id)

        eventRef.updateData([
            "rsvps": FieldValue.arrayUnion([uid])
        ]) { error in
            if let error = error {
                print("Failed to RSVP: \(error)")
            } else {
                print("RSVP success")
                self.navigateToConfirmation()
            }
        }
    }

    func navigateToConfirmation() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let confirmVC = storyboard.instantiateViewController(withIdentifier: "RSVPConfirmationViewController") as? RSVPConfirmationViewController {
            confirmVC.eventID = event?.id ?? ""
            confirmVC.eventTitle = event?.title ?? ""
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd, yyyy"
            confirmVC.eventDate = formatter.string(from: event?.date ?? Date())
            self.present(confirmVC, animated: true)
        }
    }
}

import UIKit
import FirebaseFirestore

class RSVPStatusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var attendees: [RSVPModel] = []
    var eventId: String = "event_001"  // Replace dynamically

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchAttendees()
    }

    func fetchAttendees() {
        Firestore.firestore()
            .collection("events")
            .document(eventId)
            .collection("attendees")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching attendees: \(error)")
                    return
                }

                self.attendees = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    let name = data["name"] as? String ?? "Unknown"
                    let status = data["status"] as? String ?? "Maybe"
                    return RSVPModel(userId: doc.documentID, name: name, status: status)
                } ?? []

                self.tableView.reloadData()
            }
    }

    func updateRSVP(for index: Int, to status: String) {
        let attendee = attendees[index]
        attendees[index].status = status

        Firestore.firestore()
            .collection("events")
            .document(eventId)
            .collection("attendees")
            .document(attendee.userId)
            .updateData([
                "status": status,
                "timestamp": FieldValue.serverTimestamp()
            ]) { error in
                if let error = error {
                    print("❌ Error updating RSVP: \(error.localizedDescription)")
                } else {
                    print("✅ RSVP updated to \(status) for \(attendee.name)")
                    // Optional: Notify event organizer
                }
            }
    }

    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendees.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = attendees[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSVPCell", for: indexPath) as! RSVPTableViewCell

        cell.nameLabel.text = model.name
        cell.segmentedControl.selectedSegmentIndex = segmentIndex(for: model.status)
        cell.segmentChanged = { [weak self] newStatus in
            self?.updateRSVP(for: indexPath.row, to: newStatus)
        }

        return cell
    }

    func segmentIndex(for status: String) -> Int {
        switch status {
        case "Accept": return 0
        case "Maybe": return 1
        case "Decline": return 2
        default: return 1
        }
    }
}

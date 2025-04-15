import UIKit

class RSVPTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    var segmentChanged: ((String) -> Void)?

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        let status = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "Maybe"
        segmentChanged?(status)
    }
}

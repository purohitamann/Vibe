import UIKit
import FirebaseAuth

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
}

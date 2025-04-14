import Foundation
import FirebaseFirestore

struct Event {
    var id: String
    var title: String
    var date: Date
    var location: String
    var description: String

    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "date": Timestamp(date: date),
            "location": location,
            "description": description
        ]
    }

    static func fromDocument(_ doc: DocumentSnapshot) -> Event? {
        guard let data = doc.data(),
              let title = data["title"] as? String,
              let location = data["location"] as? String,
              let timestamp = data["date"] as? Timestamp,
              let description = data["description"] as? String else {
            return nil
        }

        return Event(id: doc.documentID, title: title, date: timestamp.dateValue(), location: location, description: description)
    }
}

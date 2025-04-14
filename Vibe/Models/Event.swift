import Foundation
import FirebaseFirestore

struct Event {
    var id: String
    var title: String
    var date: Date
    var location: String
    var description: String

    static func fromDocument(_ doc: DocumentSnapshot) -> Event? {
        let data = doc.data()
        guard let title = data?["title"] as? String,
              let timestamp = data?["date"] as? Timestamp,
              let location = data?["location"] as? String,
              let description = data?["description"] as? String else {
            return nil
        }

        return Event(
            id: doc.documentID,
            title: title,
            date: timestamp.dateValue(),
            location: location,
            description: description
        )
    }

    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "date": Timestamp(date: date),
            "location": location,
            "description": description
        ]
    }
}


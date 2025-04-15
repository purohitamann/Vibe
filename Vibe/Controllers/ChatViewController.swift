//
//  ChatViewController.swift
//  Vibe
//
//  Created by Siddharth Lamba on 2025-04-14.
//

import UIKit
import FirebaseDatabase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!

    var messages: [Message] = []
    var ref: DatabaseReference!
    let eventId = "event1" // Replace with dynamic ID later
    let currentUser = "John" // Replace with dynamic user name if needed

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Event Chat"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60

        ref = Database.database().reference().child("chats").child(eventId)
        observeMessages()
    }

    @IBAction func sendMessage(_ sender: UIButton) {
        guard let text = messageField.text, !text.isEmpty else { return }

        let messageData: [String: Any] = [
            "senderName": currentUser,
            "content": text,
            "timestamp": Date().timeIntervalSince1970
        ]
        ref.childByAutoId().setValue(messageData)
        messageField.text = ""
    }

    func observeMessages() {
        ref.observe(.value) { snapshot in
            var newMessages: [Message] = []

            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any],
                   let sender = value["senderName"] as? String,
                   let content = value["content"] as? String,
                   let timestamp = value["timestamp"] as? TimeInterval {

                    let message = Message(id: snap.key,
                                          senderName: sender,
                                          content: content,
                                          timestamp: timestamp)
                    newMessages.append(message)
                }
            }

            self.messages = newMessages.sorted { $0.timestamp < $1.timestamp }
            self.tableView.reloadData()

            // Auto scroll to last message
            if self.messages.count > 0 {
                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    // MARK: - TableView Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let msg = messages[indexPath.row]
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
//        cell.textLabel?.numberOfLines = 0
//        cell.textLabel?.text = "\(msg.senderName): \(msg.content)\n🕒 \(formatTimestamp(msg.timestamp))"
//
//        // Basic bubble styling
//        cell.backgroundColor = msg.senderName == currentUser ? UIColor.systemGreen.withAlphaComponent(0.2) : UIColor.systemGray5
//        cell.textLabel?.textAlignment = msg.senderName == currentUser ? .right : .left
//        cell.layer.cornerRadius = 12
//        cell.clipsToBounds = true
//
//        return cell
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = messages[indexPath.row]
        let isCurrentUser = msg.senderName == currentUser

        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)

        // Remove old views
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let label = UILabel()
        label.numberOfLines = 0
        label.text = "\(msg.senderName): \(msg.content)\n🕒 \(formatTimestamp(msg.timestamp))"
        label.textAlignment = isCurrentUser ? .right : .left
        //label.backgroundColor = isCurrentUser ? UIColor.systemBlue.withAlphaComponent(0.2) : UIColor.systemGray5
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false

        cell.contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
            isCurrentUser
                ? label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16)
                : label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            label.widthAnchor.constraint(lessThanOrEqualToConstant: 280)
        ])

        return cell
    }
    
    func formatTimestamp(_ time: TimeInterval) -> String {
            let date = Date(timeIntervalSince1970: time)
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .none
            return formatter.string(from: date)
        }

}

//
//  EventDetailsViewController.swift
//  Vibe
//
//  Created by Aman Purohit on 2025-03-26.
//
//  Updated and added the code by Reshmi Patel
import UIKit
import FirebaseFirestore
class EventDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!

    var events: [Event] = []
    var selectedEvent: Event?
  

        override func viewDidLoad() {
            super.viewDidLoad()

            tableView.delegate = self
            tableView.dataSource = self

            emptyLabel.isHidden = true
            tableView.isHidden = true
           
            fetchEvents()

            updateUI()
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            fetchEvents()
        }

        func fetchEvents() {
            let db = Firestore.firestore()
            db.collection("events").getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching events: \(error)")
                    return
                }

                self.events = snapshot?.documents.compactMap { doc in
                    return Event.fromDocument(doc)
                } ?? []

                self.updateUI()
            }
        }

        func updateUI() {
            if events.isEmpty {
                tableView.isHidden = true
                emptyLabel.isHidden = false
                emptyLabel.text = "No Events Found\nTap '+' to create one."
                emptyLabel.textAlignment = .center
                emptyLabel.numberOfLines = 0
            } else {
                tableView.isHidden = false
                emptyLabel.isHidden = true
            }

            tableView.reloadData()
        }

        // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedEvent = events[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let rsvpVC = storyboard.instantiateViewController(withIdentifier: "RSVPController") as? RSVPController {
            rsvpVC.event = selectedEvent
            self.navigationController?.pushViewController(rsvpVC, animated: true)
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRSVP",
           let rsvpVC = segue.destination as? RSVPController {
            rsvpVC.event = selectedEvent
        } else if segue.identifier == "showUpdate",
                  let destinationVC = segue.destination as? EventUpdateViewController {
            destinationVC.event = selectedEvent
        }
    }


        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return events.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
            let event = events[indexPath.row]
            cell.textLabel?.text = event.title
            cell.accessoryType = .disclosureIndicator
            return cell
        }
//
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            tableView.deselectRow(at: indexPath, animated: true)
//            let selectedEvent = events[indexPath.row]
//              print("Selected event: \(selectedEvent.title)")
//            performSegue(withIdentifier: "showUpdate", sender: self)
//           
//            // TODO: Navigate to Event Detail later
//            print("Selected event: \(events[indexPath.row].title)")
//            
//        }

    
        // MARK: - Create Button Action

        @IBAction func newEventTapped(_ sender: Any) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let createVC = storyboard.instantiateViewController(withIdentifier: "CreateEventViewController") as? CreateEventViewController {
                self.navigationController?.pushViewController(createVC, animated: true)
            }
        }
    @IBAction func unwindToEventList(segue: UIStoryboardSegue) {
      
       fetchEvents()
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showUpdate",
//           let destinationVC = segue.destination as? EventUpdateViewController {
//            destinationVC.event = selectedEvent
//        }
//    }
    }

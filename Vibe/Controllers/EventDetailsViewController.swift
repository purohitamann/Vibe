//
//  EventDetailsViewController.swift
//  Vibe
//
//  Updated and added the code by Reshmi Patel
//  This view controller displays a list of events using table view from Firestore.
//  It allows navigation to create a new event or update an existing one.
import UIKit
import FirebaseFirestore
class EventDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!

    var events: [Event] = []
    var selectedEvent: Event?
  
    // func will be called after view is loded in memory
        override func viewDidLoad() {
            super.viewDidLoad()
            // Set table view delegate and data source
            tableView.delegate = self
            tableView.dataSource = self
            // Hide views until events are fetched
            emptyLabel.isHidden = true
            tableView.isHidden = true
           
            fetchEvents()    //fetch data from firebase

            updateUI()    //Update based on firebase updated code
        }    
        // func will be called before the view will appear
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            fetchEvents()
        }
         // Saved under "events" collection it fetches all events from the Firestore
        func fetchEvents() {
            let db = Firestore.firestore()
            db.collection("events").getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching events: \(error)")
                    return
                }
                // Convert Firestore documents to Event objects
                self.events = snapshot?.documents.compactMap { doc in
                    return Event.fromDocument(doc)
                } ?? []

                self.updateUI() // after fetching it will Update UI
            }
        }
        // based on the presence or absence of events it updates elements
        func updateUI() {
            if events.isEmpty {
                // Show empty message if no events are found
                tableView.isHidden = true
                emptyLabel.isHidden = false
                emptyLabel.text = "No Events Found\nTap '+' to create one."
                emptyLabel.textAlignment = .center
                emptyLabel.numberOfLines = 0
            } else {
                 // Show table if events are available
                tableView.isHidden = false
                emptyLabel.isHidden = true
            }

            tableView.reloadData()
        }

        
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

    
       
 // works when "+" button is tapped to create a new event
        @IBAction func newEventTapped(_ sender: Any) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let createVC = storyboard.instantiateViewController(withIdentifier: "CreateEventViewController") as? CreateEventViewController {
                self.navigationController?.pushViewController(createVC, animated: true)
            }
        }
    //Prepares data before navigating to the update screen
    @IBAction func unwindToEventList(segue: UIStoryboardSegue) {
      
       fetchEvents()
    }

    }

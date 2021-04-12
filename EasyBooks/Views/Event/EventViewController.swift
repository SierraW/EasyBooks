//
//  EventViewController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-04-05.
//

import UIKit

protocol EventViewControllerDataSource {
    var event: EBEvent? { get set }
}

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Active Events" : "Past Events"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return uncompleteEvent.count
        } else {
            return completeEvent.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ECell") ?? UITableViewCell(style: .value1, reuseIdentifier: "ECell")
        let event: EBEvent
        if indexPath.section == 0 {
            event = uncompleteEvent[indexPath.row]
            
        } else {
            event = completeEvent[indexPath.row]
        }
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = dateFormatter.string(from: event.dateCreated!)
        return cell
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let dateFormatter = (UIApplication.shared.delegate as! AppDelegate).officialDateFormatter
    
    var events: [EBEvent]? {
        didSet {
            if let events = events {
                for event in events {
                    if event.completed {
                        completeEvent.append(event)
                    } else {
                        uncompleteEvent.append(event)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    var uncompleteEvent: [EBEvent] = []
    var completeEvent: [EBEvent] = []
    var dataSource: EventViewControllerDataSource?
    
    @IBOutlet weak var learnMoreButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fetchEvents() {
        do {
            events = try context.fetch(EBEvent.fetchRequest())
        } catch {
            print("Cannot fetch Event")
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  BunnyBillViewController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-04-08.
//

import UIKit

class BunnyBillViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Uncomplete Bills" : "Completed Bills"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? uncompleteBills.count : completedBills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BBCell") ?? UITableViewCell(style: .value1, reuseIdentifier: "BBCell")
        let bills: [EBBunnyBill]
        if indexPath.section == 0 {
            bills = uncompleteBills
        } else {
            bills = completedBills
        }
        let bill = bills[indexPath.row]
        cell.textLabel?.text = bill.bunny?.name
        cell.detailTextLabel?.text = "\(bill.unit?.symbol ?? "$")\(bill.amount ?? 0.0)"
        
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var bunnyBills: [EBBunnyBill]? {
        didSet {
            
        }
    }
    
    var completedBills: [EBBunnyBill] = []
    var uncompleteBills: [EBBunnyBill] = []
    
    var dataSource: EventViewControllerDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchBunnyBills()
    }
    
    func fetchBunnyBills() {
        if let dataSource = dataSource, let event = dataSource.event, let set = event.bills, let bunnyBills = set.allObjects as? [EBBunnyBill] {
            completedBills = []
            uncompleteBills = []
            for bill in bunnyBills {
                if bill.completed {
                    completedBills.append(bill)
                } else {
                    uncompleteBills.append(bill)
                }
            }
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

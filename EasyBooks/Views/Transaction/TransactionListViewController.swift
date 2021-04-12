//
//  TransactionListViewController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-03-29.
//

import UIKit
import CoreData

class TransactionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransanctionCell", for: indexPath)
        let item = self.items![indexPath.row]
        cell.textLabel?.text = delegate.officialDateFormatter.string(from: item.dateCreated!)
        cell.detailTextLabel?.text = "\(item.unit?.prefix ?? "Err") \(item.amount ?? 0)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, _) in
            print("here")
        }
        let edit = UISwipeActionsConfiguration(actions: [action])
        return edit
    }
    

    @IBOutlet weak var transactionTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items: [EBTransaction]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        
        fetchTransactions()
    }
    
    func fetchTransactions() {
        do {
            self.items = try context.fetch(EBTransaction.fetchRequest())
            
            DispatchQueue.main.async {
                self.transactionTableView.reloadData()
            }
        } catch {
            print("Could not get transactions.")
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

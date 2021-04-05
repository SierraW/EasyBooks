//
//  CurrencyUnitViewController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-04-04.
//

import UIKit
import CoreData

protocol CurrencyUnitViewControllerDelegate {
    var context: NSManagedObjectContext { get }
    func fetchCurrencyUnits()
}

class CurrencyUnitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CurrencyUnitViewControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return currencyUnits?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : "Unit Selection"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CUCell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = "New Currency Unit..."
        } else {
            if let currencyUnits = currencyUnits {
                cell.textLabel?.text = currencyUnits[indexPath.row].prefix
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let units = currencyUnits {
            let unit = units[indexPath.row]
            context.delete(unit)
            do {
                try context.save()
                fetchCurrencyUnits()
            } catch {
                print("Cannot delect CU.")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            handleAddNewCU()
        } else if transactionAdditionViewControllerDataSource != nil, let currencyUnits = currencyUnits {
            let unit = currencyUnits[indexPath.row]
            transactionAdditionViewControllerDataSource!.unit = unit
            dismiss(animated: true, completion: nil)
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var currencyUnits: [EBCurrencyUnit]?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var transactionAdditionViewControllerDataSource: TransactionAdditionViewControllerDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CUCell")
        
        fetchCurrencyUnits()
    }
    
    func handleAddNewCU() {
        let vc = CurrencyUnitAdditionViewController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func fetchCurrencyUnits() {
        do {
            currencyUnits = try context.fetch(EBCurrencyUnit.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Cannot fetch cu.")
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

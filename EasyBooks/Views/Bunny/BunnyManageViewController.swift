//
//  BunnyManageViewController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-03-30.
//

import UIKit

protocol BunnyManageViewControllerDelegate {
    func fetchBunnys()
}

class BunnyManageViewController: UIViewController, BunnyManageViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bunnys?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BunnyCell", for: indexPath)
        if let bunnys = bunnys {
            let bunny = bunnys[indexPath.row]
            cell.textLabel?.text = bunny.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if transactionAdditionViewControllerDataSource != nil {
            if let bunnys = bunnys {
                let bunny = bunnys[indexPath.row]
                transactionAdditionViewControllerDataSource!.bunny = bunny
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let bunnys = bunnys {
                let bunny = bunnys[indexPath.row]
                context.delete(bunny)
                do {
                    try context.save()
                    self.present(alertController.get(with: nil, instruction: "\(bunny.name ?? "Some") has been deleted.", handler: nil), animated: true, completion: nil)
                    self.fetchBunnys()
                } catch {
                    print("Delete bunny failed")
                }
            }
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var bunnys: [EBBunny]?
    
    let alertController = CompleteAlertController()
    
    var transactionAdditionViewControllerDataSource: TransactionAdditionViewControllerDataSource?

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var bunnyTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bunnyTableView.delegate = self
        bunnyTableView.dataSource = self
        bunnyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "BunnyCell")
        
        fetchBunnys()
        
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
    }
    
    func fetchBunnys() {
        do {
            self.bunnys = try context.fetch(EBBunny.fetchRequest())
            DispatchQueue.main.async {
                self.bunnyTableView.reloadData()
            }
        } catch {
            print("Could not load bunnys.")
        }
    }
    
    @objc func addButtonClicked() {
        let vc = BunnyAdditonViewController()
        vc.delegate = self
        vc.alertController = self.alertController
        present(vc, animated: true, completion: nil)
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

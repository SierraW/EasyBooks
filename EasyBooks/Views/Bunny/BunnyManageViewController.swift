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

protocol BunnyManageViewControllerDataSource {
    var bunny: EBBunny? { get set }
    
    func checkExist(with name: String) -> Bool
}

class BunnyManageViewController: UIViewController, BunnyManageViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bunnys?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BunnyCell") ?? UITableViewCell(style: .value1, reuseIdentifier: "BunnyCell")
        if let bunnys = bunnys {
            let bunny = bunnys[indexPath.row]
            cell.textLabel?.text = bunny.name
            
            if mode == .Event {
                if let dataSource = dataSource, let name = bunny.name, dataSource.checkExist(with: name) {
                    cell.detailTextLabel?.text = "✓"
                } else {
                    cell.detailTextLabel?.text = "𐄂"
                }
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource != nil, let bunnys = bunnys {
            let bunny = bunnys[indexPath.row]
            if mode == .Event, let dataSource = dataSource, let name = bunny.name, dataSource.checkExist(with: name) {
                return
            }
            dataSource!.bunny = bunny
            self.dismiss(animated: true, completion: nil)
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
    
    var dataSource: BunnyManageViewControllerDataSource?
    
    var mode: Mode = .Legacy
    
    enum Mode {
        case Legacy, Event
    }

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var bunnyTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bunnyTableView.delegate = self
        bunnyTableView.dataSource = self
        
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

//
//  TagViewController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-04-04.
//

import UIKit
import CoreData

protocol TagViewControllerDelegate {
    var context: NSManagedObjectContext { get }
    func fetchTags()
    var mode: TagViewController.Mode { get set }
}

protocol TagViewControllerDataSource {
    var tags: [EBTag]? { get }
}

class TagViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TagViewControllerDelegate, TagViewControllerDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return mode == .normal ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : "Selections"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mode == .selectOnly {
            return tags?.count ?? 0
        }
        return section == 0 ? 1 : tags?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let tags = tags {
                let tag = tags[indexPath.row]
                context.delete(tag)
                do {
                    try context.save()
                    fetchTags()
                } catch {
                    print("Failed to delete tag.")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "reuseIdentifier")
        }
        if indexPath.section == 0 && mode == .normal{
            cell!.textLabel?.text = "Add a New Tag..."
        } else {
            if let tags = tags {
                let tag = tags[indexPath.row]
                cell!.textLabel?.text = tag.name
                cell!.detailTextLabel?.text = tag.parent == nil ? "Root" : tag.parent!
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mode == .normal && indexPath.section == 0 {
            presentTagAdditionVC()
        } else {
            if parentTagDataSource != nil, let tags = tags {
                let tag = tags[indexPath.row]
                parentTagDataSource!.parentTag = tag.name
                dismiss(animated: true, completion: nil)
            } else if transactionAdditionViewControllerDataSource != nil, let tags = tags {
                let tag = tags[indexPath.row]
                transactionAdditionViewControllerDataSource?.tag = tag
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewRefreshButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tags: [EBTag]?
    
    var mode = Mode.normal
    
    enum Mode {
        case selectOnly, normal
    }
    
    var parentTagDataSource: TagAdditionViewControllerDataSource?
    
    var transactionAdditionViewControllerDataSource: TransactionAdditionViewControllerDataSource?
    
    let tagTreeGenerator = TagTreeGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        fetchTags()
        
        if mode == .selectOnly {
            textView.isHidden = true
        }
        
        textViewRedraw()
        
        textViewRefreshButton.addTarget(self, action: #selector(textViewRedraw), for: .touchUpInside)
    }
    
    @objc func textViewRedraw() {
        if let tags = tags {
            self.tagTreeGenerator.generateTagTree(with: tags)
            self.textView.text = self.tagTreeGenerator.treeToString()
        }
    }
    
    func fetchTags() {
        do {
            tags = try context.fetch(EBTag.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Cannot fetch tags.")
        }
    }
    
    func presentTagAdditionVC() {
        let vc = TagAdditionViewController()
        vc.tagViewControllerDelegate = self
        vc.alertController = CompleteAlertController()
        vc.tagViewControllerDataSource = self
        self.present(vc, animated: true, completion: nil)
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

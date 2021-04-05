//
//  BunnyAdditonViewController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-03-30.
//

import UIKit
import CoreData

class BunnyAdditonViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    var delegate: BunnyManageViewControllerDelegate?
    var alertController: AlertController?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addButton.addTarget(self, action: #selector(submitData), for: .touchUpInside)
        descriptionTextView.text = "Default text goes here"
    }
    
    @objc func submitData() {
        
        let newBunny = NSEntityDescription.insertNewObject(forEntityName: "EBBunny", into: context) as! EBBunny
        newBunny.name = nameTextField.text ?? ""
        newBunny.des = descriptionTextView.text
        
        do {
            try context.save()
            if let alertController = alertController {
                self.present(alertController.get(with: nil, instruction: "Successfully added person", handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }), animated: true, completion: nil)
            }
            delegate?.fetchBunnys()
        } catch {
            print(error.localizedDescription)
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

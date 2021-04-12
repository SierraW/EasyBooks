//
//  TagAdditionViewController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-04-04.
//

import UIKit
import CoreData

protocol TagAdditionViewControllerDataSource {
    var parentTag: String? { get set }
}

class TagAdditionViewController: UIViewController, TagAdditionViewControllerDataSource {
    var parentTag: String? {
        didSet {
            parentTagButton.setTitle(parentTag, for: .normal)
        }
    }
    
    var tagViewControllerDelegate: TagViewControllerDelegate?
    
    var alertController: AlertController?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var parentTagButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parentTagButton.addTarget(self, action: #selector(presentParentSelectionVC), for: .touchUpInside)
        
        ButtonStyler.addPrimaryStyle(to: submitButton)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
    }
    
    @objc func presentParentSelectionVC() {
        let vc = TagViewController()
        vc.mode = .selectOnly
        vc.parentTagDataSource = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func handleSubmit() {
        if let delegate = tagViewControllerDelegate, let newName = nameTextField.text, !delegate.contains(tagName: newName) {
            if let alertController = self.alertController {
                self.present(alertController.get(with: "Failed", instruction: "Duplicated tag detected.", handler: nil), animated: true, completion: nil)
            }
            let tag = NSEntityDescription.insertNewObject(forEntityName: "EBTag", into: delegate.context) as! EBTag
            tag.name = nameTextField.text
            tag.parent = parentTag
            do {
                try delegate.context.save()
                if let alertController = alertController {
                    self.present(alertController.get(with: nil, instruction: "Tag Successfully Added", handler: { _ in
                        self.dismiss(animated: true, completion: nil)
                    }), animated: true, completion: nil)
                } else {
                    dismiss(animated: true, completion: nil)
                }
            } catch {
                print("Tag add failed")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let delegate = tagViewControllerDelegate {
            delegate.fetchTags()
        }
        super.viewWillDisappear(animated)
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

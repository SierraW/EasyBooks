//
//  TransactionAdditionViewController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-03-29.
//

import UIKit
import CoreData

class TransactionAdditionViewController: UIViewController, CurrencyUnitViewControllerDataSource, BunnyManageViewControllerDataSource, TagViewControllerDataSource, UITextFieldDelegate, EventViewControllerDataSource {
    
    func checkExist(with name: String) -> Bool {
        return false
    }
    
    var bunny: EBBunny? {
        didSet {
            bunnyButton.setTitle(bunny?.name, for: .normal)
        }
    }
    
    var currencyUnit: EBCurrencyUnit? {
        didSet {
            unitButton.setTitle(currencyUnit?.prefix, for: .normal)
        }
    }
    
    var tag: EBTag? {
        didSet {
            tagButton.setTitle(tag?.name, for: .normal)
        }
    }
    
    var event: EBEvent? {
        didSet {
            eventButton.setTitle(event?.name, for: .normal)
            bunnyButton.isHidden = false
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var bunnyButton: UIButton!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var unitButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    let alertController: AlertController? = CompleteAlertController()
    let amountTextFieldController = AmountTextFieldController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountTextField.textAlignment = .right
        amountTextField.addTarget(amountTextFieldController, action: #selector(amountTextFieldController.textFieldDidChange(_:)), for: .editingChanged)
        amountTextField.delegate = self

        addButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        bunnyButton.addTarget(self, action: #selector(presentBunnyManageVC), for: .touchUpInside)
        unitButton.addTarget(self, action: #selector(presentCurrencyUnitManageVC), for: .touchUpInside)
        tagButton.addTarget(self, action: #selector(presentTagManageVC), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(presentEventVC), for: .touchUpInside)
        bunnyButton.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @objc func handleSubmit() {
        if let warnings = checkFields() {
            var warningsMsg = "Please check the following fields: "
            for warning in warnings {
                warningsMsg.append("\(warning) ")
            }
            if let alertController = alertController {
                self.present(alertController.get(with: nil, instruction: "One or more fields empty.", handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }), animated: true, completion: nil)
            }
            return
        }
        let trans = NSEntityDescription.insertNewObject(forEntityName: "EBTransaction", into: context) as! EBTransaction
        trans.amount = amountTextFieldController.getAmount() as NSDecimalNumber?
        trans.des = descriptionTextField.text
        trans.bunny = bunny
        trans.unit = currencyUnit
        trans.tag = tag
        trans.event = event
        do {
            try context.save()
            if let alertController = alertController {
                self.present(alertController.get(with: nil, instruction: "Successfully added person", handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }), animated: true, completion: nil)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkFields() -> [String]? {
        return nil
    }
    
//    @objc func presentExampleVC() {
//        let vc = ViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//
////        vc.modalPresentationStyle = .fullScreen
////        present(vc, animated: true, completion: nil)
//    }
    
    @objc func presentEventVC() {
        let vc = EventViewController()
        vc.dataSource = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentBunnyManageVC() {
        let vc = BunnyManageViewController()
        vc.dataSource = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentCurrencyUnitManageVC() {
        let vc = CurrencyUnitViewController()
        vc.dataSource = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentTagManageVC() {
        let vc = TagViewController()
        vc.dataSource = self
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

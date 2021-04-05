//
//  CurrencyUnitAdditionViewController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-04-04.
//

import UIKit
import CoreData

class CurrencyUnitAdditionViewController: UIViewController {
    
    var delegate: CurrencyUnitViewControllerDelegate!
    
    var alertController: AlertController?
    @IBOutlet weak var symbolTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var prefixTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        symbolTextField.addTarget(self, action: #selector(handleSymbolFinished), for: .editingDidEnd)
        
        ButtonStyler.addPrimaryStyle(to: submitButton)
        
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
    }
    
    @objc func handleSymbolFinished() {
        if let text = symbolTextField.text, text.count > 1 {
            symbolTextField.text! = text[0]
        }
    }
    
    @objc func handleSubmit() {
        let newCU = NSEntityDescription.insertNewObject(forEntityName: "EBCurrencyUnit", into: delegate.context) as! EBCurrencyUnit
        newCU.name = nameTextField.text
        newCU.prefix = prefixTextField.text
        newCU.symbol = symbolTextField.text
        do {
            try delegate.context.save()
            if let alertController = alertController {
                self.present(alertController.get(with: nil, instruction: "Curreny Unit Successfully Added", handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }), animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            
        } catch {
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate.fetchCurrencyUnits()
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

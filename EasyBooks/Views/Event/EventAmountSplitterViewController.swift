//
//  EventAmountSplitterViewController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-04-11.
//

import UIKit

protocol EventAmountSplitterViewControllerDataSource {
    var bunnyBills: [EBBunnyBill] { get set }
    func getTotalAmount() -> Decimal?
}

protocol EventAmountSplitterViewControllerDelegate {
    func handleAmountChange()
}

class EventAmountSplitterViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, BunnyBillTableViewCellDataSource {
    func getTotalAmount() -> Decimal? {
        return Decimal(string: textField.text ?? "0")?.rounded(2)
    }
    
    func valueChanged(for bill: EBBunnyBill, _ amount: Decimal) {
        dict[bill] = amount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.bunnyBills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EASCell") as? BunnyBillTableViewCell ?? BunnyBillTableViewCell(style: .default, reuseIdentifier: "EASCell")
        let bill = dataSource.bunnyBills[indexPath.row]
        cell.dataSource = self
        cell.bunnyBill = bill
        cell.reloadData()
        return cell
    }
    

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    var dataSource: EventAmountSplitterViewControllerDataSource!
    
    var delegate: EventAmountSplitterViewControllerDelegate!
    
    let amountTextFieldController = AmountTextFieldController()
    
    var dict: [EBBunnyBill: Decimal] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for bill in dataSource.bunnyBills {
            dict[bill] = 0
        }

        ButtonStyler.addPrimaryStyle(to: submitButton)
        
        textField.delegate = self
        textField.addTarget(amountTextFieldController, action: #selector(amountTextFieldController.textFieldDidChange(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(handleAmountChange), for: .editingDidEnd)
        
        submitButton.addTarget(self, action: #selector(calculatePercentage), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @objc func handleAmountChange() {
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @objc func calculatePercentage() {
        let thisAmount = amountTextFieldController.getAmount()
        if let totalAmount = dataSource.getTotalAmount() {
            for bill in dataSource.bunnyBills {
                if let partial = dict[bill], partial != 0 {
                    bill.amount = NSDecimalNumber(decimal: ( dict[bill]! / thisAmount) * totalAmount)
                }
                
            }
        }
        
        self.delegate.handleAmountChange()
        dismiss(animated: true, completion: nil)
    }

}

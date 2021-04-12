//
//  EventAdditionViewController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-04-08.
//

import UIKit
import CoreData

class EventAdditionViewController: UIViewController, CurrencyUnitViewControllerDataSource, BunnyManageViewControllerDataSource, BunnyBillTableViewCellDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, EventAmountSplitterViewControllerDataSource, UIViewControllerTransitioningDelegate, EventAmountSplitterViewControllerDelegate, TagViewControllerDataSource {
    var tag: EBTag? {
        didSet {
            tagButton.setTitle(tag!.name, for: .normal)
        }
    }
    
    func getTotalAmount() -> Decimal? {
        return Decimal(string: amountTextField.text ?? "0")?.rounded(2)
    }
    
    func valueChanged(for bill: EBBunnyBill, _ amount: Decimal) {
        bill.amount = NSDecimalNumber(decimal: amount)
        calcualateEstimateAmount()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return TransactionPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bunnyBills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EABCell") as? BunnyBillTableViewCell ?? BunnyBillTableViewCell(style: .default, reuseIdentifier: "EABCell")
        cell.dataSource = self
        let bunnyBill = bunnyBills[indexPath.row]
        cell.bunnyBill = bunnyBill
        cell.reloadData()
        return cell
    }
    
    func checkExist(with name: String) -> Bool {
        return bunnyBills.contains { bill -> Bool in
            if let bunny = bill.bunny, let bn = bunny.name {
                return name == bn
            }
            return false
        }
    }
    
    var bunny: EBBunny? {
        didSet {
            addBunnyBill()
        }
    }
    
    var currencyUnit: EBCurrencyUnit? {
        didSet {
            calcualateEstimateAmount()
        }
    }
    

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var balanceTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var learnButton: UIButton!
    @IBOutlet weak var splitButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var splitterButton: UIButton!
    
    var bunnyBills: [EBBunnyBill] = [] {
        didSet {
            calcualateEstimateAmount()
            tableView.reloadData()
        }
    }
    
    let amountTextFieldController = AmountTextFieldController()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ButtonStyler.addPrimaryStyle(to: submitButton)
        
        amountTextField.textAlignment = .right
        amountTextField.addTarget(amountTextFieldController, action: #selector(amountTextFieldController.textFieldDidChange(_:)), for: .editingChanged)
        amountTextField.addTarget(self, action: #selector(handleAmountChange), for: .editingDidEnd)
        amountTextField.delegate = self
        tagButton.addTarget(self, action: #selector(presentTagVC), for: .touchUpInside)
        currencyButton.addTarget(self, action: #selector(presentCurrencySelectionView), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(presentBunnySelectionView), for: .touchUpInside)
        splitButton.addTarget(self, action: #selector(splitEqually), for: .touchUpInside)
        splitterButton.addTarget(self, action: #selector(presentSplitterVC), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        
        calcualateEstimateAmount()
    }
    
    @objc func handleAmountChange() {
        self.calcualateEstimateAmount()
        tableView.reloadData()
    }
    
    func calcualateEstimateAmount() {
        if let currency = currencyUnit {
            var totalAmount = getTotalAmount() ?? 0
            for bill in bunnyBills {
                if let amount = bill.amount {
                    totalAmount -= amount as Decimal
                }
            }
            
            balanceTextView.text = "\(currency.prefix ?? "u") \(currency.symbol ?? "$")\(totalAmount)"
        } else {
            balanceTextView.text = "Please select a Currency."
        }
    }
    
    @objc func presentTagVC() {
        let vc = TagViewController()
        vc.dataSource = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentSplitterVC() {
        let vc = EventAmountSplitterViewController()
        vc.dataSource = self
        vc.delegate = self
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentCurrencySelectionView() {
        let vc = CurrencyUnitViewController()
        vc.dataSource = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentBunnySelectionView() {
        let vc = BunnyManageViewController()
        vc.dataSource = self
        vc.mode = .Event
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func splitEqually() {
        let totalAmount = Decimal(string: amountTextField.text ?? "0") ?? 0
        if totalAmount != 0, bunnyBills.count > 0 {
            let slice = totalAmount / Decimal(bunnyBills.count)
            for bill in bunnyBills {
                bill.amount = slice as NSDecimalNumber
            }
            tableView.reloadData()
        }
    }
    
    @objc func handleSubmit() {
        let event = NSEntityDescription.insertNewObject(forEntityName: "EBEvent", into: context) as! EBEvent
        for bill in bunnyBills {
            bill.event = event
            bill.completed = false
        }
        event.bills = Set<EBBunnyBill>(bunnyBills) as NSSet
        event.completed = false
        event.tag = tag
        event.name = nameTextField.text
        event.dateCreated = Date()
        do {
            try context.save()
            dismiss(animated: true, completion: nil)
        } catch {
            print("Unable to save event.")
        }
    }
    
    func checkFields() -> Bool {
        // TODO: implement
        return true
    }
    
    func addBunnyBill() {
        if let bunny = bunny, let name = bunny.name,  !checkExist(with: name) {
            let bunnyBill = NSEntityDescription.insertNewObject(forEntityName: "EBBunnyBill", into: context) as! EBBunnyBill
            bunnyBill.bunny = bunny
            bunnyBill.completed = false
            bunnyBill.unit = currencyUnit
            bunnyBill.amount = 0
            self.bunnyBills.append(bunnyBill)
        }
    }

}

//
//  BunnyBillTableViewCell.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-04-11.
//

import UIKit

protocol BunnyBillTableViewCellDataSource {
    func getTotalAmount() -> Decimal?
    
    func valueChanged(for bill: EBBunnyBill, _ amount: Decimal)
}

class BunnyBillTableViewCell: UITableViewCell, UITextFieldDelegate {

    let primaryLabel = UILabel()
    let percentageLabel = UILabel()
    let amountTextField = UITextField()
    let amountTextFieldController = AmountTextFieldController()
    var bunnyBill: EBBunnyBill!
    var dataSource: BunnyBillTableViewCellDataSource!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        primaryLabel.textAlignment = NSTextAlignment.left
//        primaryLabel.font = UIFont.boldSystemFont(ofSize: 30)
//        primaryLabel.backgroundColor = UIColor.clear
//        primaryLabel.textColor = UIColor.black
        
        percentageLabel.textAlignment = NSTextAlignment.left
//        percentageLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        percentageLabel.backgroundColor = UIColor.clear
//        percentageLabel.textColor = UIColor.blue
        
        percentageLabel.text = "0.0%"
        
        amountTextField.textAlignment = .right
        amountTextField.layer.cornerRadius = 8
        amountTextField.layer.borderWidth = 1
        amountTextField.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        amountTextField.keyboardType = .numberPad
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(primaryLabel)
        contentView.addSubview(percentageLabel)
        contentView.addSubview(amountTextField)
        
        amountTextField.addTarget(amountTextFieldController, action: #selector(amountTextFieldController.textFieldDidChange(_:)), for: .editingChanged)
        amountTextField.addTarget(self, action: #selector(calculatePercentage), for: .editingDidEnd)
        amountTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func reloadData() {
        self.primaryLabel.text = bunnyBill.bunny?.name ?? "Err"
        amountTextFieldController.setAmount((bunnyBill.amount ?? 0) as Decimal)
        if let amount = bunnyBill.amount as Decimal? {
            self.amountTextField.text = "\(amount.rounded(2))"
        } else {
            self.amountTextField.text = "0"
        }
        
        calculatePercentage()
    }
    
    @objc func calculatePercentage() {
        let amount = Decimal(string: amountTextField.text ?? "0") ?? 0
        dataSource.valueChanged(for: bunnyBill, amount)
        let totalAmount = dataSource.getTotalAmount()
        if totalAmount == 0 || totalAmount == nil {
            return
        }
        let percentage = amount / totalAmount! * 100
        if percentage > 10000 {
            percentageLabel.text = ">999%"
        } else {
            percentageLabel.text = "\(percentage.rounded(1))%"
        }
        
    }
    
    override func layoutSubviews() {
        
        var f = CGRect(x: 90, y: 5, width: 130, height: 35)
        primaryLabel.frame = f

        f = CGRect(x: 230, y: 5, width: 150, height: 35)
        amountTextField.frame = f

        f = CGRect(x: 5, y: 5, width: 80, height: 35)
        percentageLabel.frame = f
        
//        percentageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//        percentageLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        
//        primaryLabel.centerYAnchor.constraint(equalTo: percentageLabel.centerYAnchor).isActive = true
//        primaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60).isActive = true
//        
//        amountTextField.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        amountTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//        amountTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

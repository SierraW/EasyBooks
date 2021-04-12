//
//  AmountTextField.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-04-10.
//

import UIKit

class AmountTextFieldController {
    
    var amountNumber: Int
    
    init() {
        amountNumber = 0
    }
    
    func getAmount() -> Decimal {
        return (Decimal(amountNumber) / 100).rounded(2)
    }
    
    func setAmount(_ amount: Decimal) {
        self.amountNumber = Int(truncating: NSDecimalNumber(decimal: amount * 100))
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            let subs = text.split(separator: ".")
            var numberStr = String(amountNumber)
            
            if subs.count == 1{
                let amountStr = String(subs[0])
                if let _ = Int(amountStr) {
                    numberStr = amountStr
                }
            } else if subs.count == 2 {
                let amountStr = String(subs[0] + subs[1])
                if let _ = Int(amountStr) {
                    numberStr = amountStr
                }
            }
            
            while numberStr[0] == "0" && numberStr.count > 1 {
                numberStr = numberStr.substring(fromIndex: 1)
            }
            
            while numberStr.count < 3 {
                numberStr.insert("0", 0)
            }
            
            amountNumber = Int(numberStr) ?? 0
            
            numberStr.insert(".", -2)
            
            textField.text = numberStr
        }
    }
}

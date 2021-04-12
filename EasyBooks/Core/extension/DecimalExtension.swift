//
//  DecimalExtension.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-04-11.
//

import Foundation

extension Decimal {
    func rounded(_ digits: Int) -> Decimal {
        let amountStr = "\(self)"
        let amountArr = amountStr.split(separator: ".")
        if amountArr.count == 1 {
            if digits == 0 {
                return self
            }
            var count = digits
            var out = "\(amountArr[0])."
            while count > 0 {
                count -= 1
                out += "0"
            }
            return Decimal(string: out)!
        }
        if amountArr[1].count == digits {
            return self
        } else if amountArr[1].count > digits {
            var out = String(amountArr[0]) + "."
            out += String(amountArr[1]).substring(toIndex: digits)
            return Decimal(string: out)!
        } else {
            var out = amountStr
            var amountNeeded = digits - amountArr[1].count
            while amountNeeded > 0 {
                amountNeeded -= 1
                out += "0"
            }
            return Decimal(string: out)!
        }
    }
}

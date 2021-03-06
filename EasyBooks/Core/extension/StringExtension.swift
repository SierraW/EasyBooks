//
//  StringExtension.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-04-04.
//

import Foundation

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    mutating func insert(_ string:String, _ pos:Int) {
        let backward = pos < 0
        let offset = backward ? -pos : pos
        if offset < self.count {
            if backward {
                self.insert(contentsOf: string, at:self.index(self.startIndex, offsetBy: self.count - offset) )
            } else {
                self.insert(contentsOf: string, at:self.index(self.startIndex, offsetBy: offset) )
            }
        }
    }
}

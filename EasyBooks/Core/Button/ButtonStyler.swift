//
//  SubmitButtonStyler.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-04-04.
//

import UIKit

class ButtonStyler {
    static func addPrimaryStyle(to submitButton: UIButton) {
        submitButton.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        submitButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

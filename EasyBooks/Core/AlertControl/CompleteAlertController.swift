//
//  ActionCompleteAlert.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-04-04.
//

import UIKit

class CompleteAlertController: AlertController {
    func get(with title: String?, instruction description: String, handler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let title = title ?? "Success"
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        return alert
    }
}

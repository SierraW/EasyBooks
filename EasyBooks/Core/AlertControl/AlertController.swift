//
//  AlertController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-04-04.
//

import UIKit

protocol AlertController {
    func get(with title: String?, instruction description: String, handler: ((UIAlertAction) -> Void)?) -> UIAlertController
}

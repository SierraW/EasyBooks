//
//  HomeTabViewController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-04-11.
//

import UIKit

class HomeTabViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var transactionAdditionButton: UIButton!
    @IBOutlet weak var eventAdditionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        transactionAdditionButton.addTarget(self, action: #selector(presentTransactionVC), for: .touchUpInside)
        eventAdditionButton.addTarget(self, action: #selector(presentEventVC), for: .touchUpInside)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return TransactionPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    @objc func presentTransactionVC() {
        let vc = TransactionAdditionViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @objc func presentEventVC() {
        let vc = EventAdditionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

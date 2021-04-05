//
//  TransactionAdditionViewController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-03-29.
//

import UIKit

protocol TransactionAdditionViewControllerDataSource {
    var bunny: EBBunny? { get set }
    var unit: EBCurrencyUnit? { get set }
    var tag: EBTag? { get set }
    var event: EBEvent? { get set }
}

class TransactionAdditionViewController: UIViewController, TransactionAdditionViewControllerDataSource {
    var bunny: EBBunny? {
        didSet {
            bunnyButton.setTitle(bunny?.name, for: .normal)
        }
    }
    
    var unit: EBCurrencyUnit? {
        didSet {
            unitButton.setTitle(unit?.prefix, for: .normal)
        }
    }
    
    var tag: EBTag? {
        didSet {
            tagButton.setTitle(tag?.name, for: .normal)
        }
    }
    
    var event: EBEvent? {
        didSet {
            eventButton.setTitle(event?.name, for: .normal)
        }
    }
    

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var bunnyButton: UIButton!
    @IBOutlet weak var unitButton: UIButton!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        addButton.addTarget(self, action: #selector(presentExampleVC), for: .touchUpInside)
        bunnyButton.addTarget(self, action: #selector(presentBunnyManageVC), for: .touchUpInside)
        unitButton.addTarget(self, action: #selector(presentCurrencyUnitManageVC), for: .touchUpInside)
        tagButton.addTarget(self, action: #selector(presentTagManageVC), for: .touchUpInside)
    }
    
    @objc func presentExampleVC() {
        let vc = ViewController()
        self.navigationController?.pushViewController(vc, animated: true)

//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
    }
    
    @objc func presentBunnyManageVC() {
        let vc = BunnyManageViewController()
        vc.transactionAdditionViewControllerDataSource = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func presentCurrencyUnitManageVC() {
        let vc = CurrencyUnitViewController()
        vc.transactionAdditionViewControllerDataSource = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentTagManageVC() {
        let vc = TagViewController()
        vc.transactionAdditionViewControllerDataSource = self
        self.present(vc, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

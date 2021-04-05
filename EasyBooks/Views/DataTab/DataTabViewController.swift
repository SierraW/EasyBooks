//
//  DataTabViewController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-03-30.
//

import UIKit

class DataTabViewController: UIViewController {

    @IBOutlet weak var bunnyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bunnyButton.addTarget(self, action: #selector(presentBunnyMangeVC), for: .touchUpInside)
        
    }
    
    @objc func presentBunnyMangeVC() {
        let vc = BunnyManageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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

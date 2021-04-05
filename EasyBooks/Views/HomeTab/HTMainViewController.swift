//
//  HTMainViewController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-03-06.
//

import UIKit

class HTMainViewController: UIViewController {

    lazy var eventReportView: EventReportView = {
        let eventReportView = EventReportView()
       eventReportView.translatesAutoresizingMaskIntoConstraints = false
        return eventReportView
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //do somthing
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(eventReportView)
        view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: eventReportView.leadingAnchor).isActive = true
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: eventReportView.trailingAnchor).isActive = true
        view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: eventReportView.topAnchor).isActive = true
        eventReportView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
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

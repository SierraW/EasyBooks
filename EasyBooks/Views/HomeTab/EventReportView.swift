//
//  EventReportView.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-03-06.
//

import UIKit

@IBDesignable
class EventReportView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        guard let contentView = self.fromNib()
        else { fatalError("View could not load from nib") }
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension UIView {
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self))
            .loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
                return nil
        }
        return contentView
    }
}

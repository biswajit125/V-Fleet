//
//  EmptyScreen.swift
//  
//
//  Created by yapapp on 4/15/19.
//

import UIKit

class EmptyScreen: UIView {

    // MARK: - IBOUTLETS
    @IBOutlet var placeholderimagView: UIImageView!
    @IBOutlet var placholderTitleLabel: UILabel!
    
    // MARK: - VIEW LIFE CYCLE
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//    }
    
    // MARK: - INTERNAL FUNCTIONS
    func addPlaceholder(isImageRequired: Bool, title: String?) {
        self.placeholderimagView.isHidden = !isImageRequired
        if let title = title {
            self.placholderTitleLabel.text = title
        }
        else {
            self.placholderTitleLabel.isHidden = true
        }
    }
}

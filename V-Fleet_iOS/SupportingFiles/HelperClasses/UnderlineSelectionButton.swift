//
//  UnderlineSelectionButton.swift
//  Whetness
//
//  Created by Kamaljeet Punia on 02/04/21.
//  Copyright © 2021 Kamaljeet Punia. All rights reserved.
//

import UIKit

class UnderlineSelectionButton: UIButton {
    // MARK: - VARIABLES
    private let unselectedBorderColor: UIColor = UIColor(named: "DarkBlue8")!
    private let unselectedTextColor: UIColor = UIColor(named: "BlueGray3")!
    private let unselectedBorderHeight: CGFloat = 1
    
    private let selectedBorderColor: UIColor = UIColor(named: "ThemeBlue")!
    private let selectedTextColor: UIColor = .white
    private let selectedBorderHeight: CGFloat = 2
    
    private let bottomBorder = CALayer()
    
    var makeSelected: Bool = false {
        didSet {
            if self.makeSelected {
                self.makeButtonSelected()
            }else {
                self.makeButtonUnselected()
            }
        }
    }
    
    // MARK: - INITIALIZERS
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.setupBottomBorder()
        }
        self.titleLabel?.textColor = self.unselectedTextColor
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupBottomBorder() {
        let y = self.frame.height - self.unselectedBorderHeight
        self.bottomBorder.frame = CGRect(x: 0, y: y, width: self.frame.width, height: self.unselectedBorderHeight)
        self.bottomBorder.backgroundColor = self.unselectedBorderColor.cgColor
        self.layer.addSublayer(self.bottomBorder)
    }
    
    private func makeButtonUnselected() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let `self` = self else {
                return
            }
            let y = self.frame.height - self.unselectedBorderHeight
            self.bottomBorder.frame.origin.y = y
            self.bottomBorder.frame.size.height = self.unselectedBorderHeight
            self.bottomBorder.backgroundColor = self.unselectedBorderColor.cgColor
            self.setTitleColor(self.unselectedTextColor, for: .normal)
        }
    }
    
    private func makeButtonSelected() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let `self` = self else {
                return
            }
            
            let y = self.frame.height - self.selectedBorderHeight
            self.bottomBorder.frame.origin.y = y
            self.bottomBorder.frame.size.height = self.selectedBorderHeight
            self.bottomBorder.backgroundColor = self.selectedBorderColor.cgColor
            self.setTitleColor(self.selectedTextColor, for: .normal)
        }
    }
}

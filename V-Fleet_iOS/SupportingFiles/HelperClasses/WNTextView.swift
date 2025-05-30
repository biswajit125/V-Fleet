//
//  WNTextView.swift
//  Whetness
//
//  Created by Kamaljeet Punia on 23/03/21.
//  Copyright © 2021 Kamaljeet Punia. All rights reserved.
//

import UIKit

class WNTextView: UITextView {
    
    // MARK: - VARIABLES
    private let wnInactiveBorderColor: UIColor? = UIColor(named: "lightBlue")
    private let wnActiveBorderColor: UIColor? = UIColor(named: "ThemeBlue")
    private let wnBorderWidth: CGFloat = 1
    private let wnCornerRadius: CGFloat = 8
    
    private let wnTextColor: UIColor = .white
    private let wnFont: UIFont = AppFont.regular.fontWithSize(12)
    
    private let placeholderColor: UIColor? = UIColor(named: "BlueGray")
    @IBInspectable var placeholderText: String? {
        didSet {
            self.setPlaceholderText()
        }
    }
    
    // MARK: - INITIALIZERS
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupTextView()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupTextView() {
        self.delegate = self
        self.setFont()
        self.addBorder()
        self.setPlaceholderText()
        self.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    private func setPlaceholderText() {
        self.text = self.placeholderText
        self.textColor = self.placeholderColor
    }
    
    private func setFont() {
        self.textColor = self.wnTextColor
        self.font = self.wnFont
    }
        
    private func addBorder() {
        self.layer.borderWidth = self.wnBorderWidth
        self.layer.borderColor = self.wnInactiveBorderColor?.cgColor
        self.layer.cornerRadius = self.wnCornerRadius
    }
    
}

// MARK: - TEXT VIEW DELEGATE
extension WNTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == self.placeholderColor {
            textView.text = nil
            textView.textColor = self.wnTextColor
        }
        self.layer.borderColor = self.wnActiveBorderColor?.cgColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.placeholderText
            textView.textColor = self.placeholderColor
        }
        self.layer.borderColor = self.wnInactiveBorderColor?.cgColor
    }
}

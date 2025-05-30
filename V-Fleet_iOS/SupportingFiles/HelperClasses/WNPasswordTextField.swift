//
//  WNPasswordTextField.swift
//  Whetness
//
//  Created by Kamaljeet Punia on 02/04/21.
//  Copyright © 2021 Kamaljeet Punia. All rights reserved.
//

import UIKit

class WNPasswordTextField: UITextField {
    
    // MARK: - VARIABLES
    private let wnInactiveBorderColor: UIColor? = UIColor(named: "lightBlue")
    private let wnActiveBorderColor: UIColor? = UIColor(named: "ThemeBlue")
    private let wnBorderWidth: CGFloat = 1
    private let wnCornerRadius: CGFloat = 8
    
    private let wnTextColor: UIColor = .white
    private let wnFont: UIFont = AppFont.regular.fontWithSize(12)
    
    private let wnPlaceholderColor: UIColor? = UIColor(named: "BlueGray")
    
    private let leftViewWidth: CGFloat = 15
    private let leftImageSize: CGFloat = 15
    private let leftImage: UIImage? = nil
    
    private let rightViewWidth: CGFloat = 42
    private let showPasswordImage: UIImage? = UIImage(named: "openEye")!
    private let hidePasswordImage: UIImage? = UIImage(named: "closeEye")!
    
    // MARK: - INITIALIZERS
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupTextField()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupTextField() {
        self.setFont()
        self.addBorder()
        self.addLeftView()
        self.addRightView()
        self.setPlaceholderColor()
        self.delegate = self
        self.isSecureTextEntry = true
    }
    
    private func setFont() {
        self.textColor = self.wnTextColor
        self.font = self.wnFont
    }
    
    private func setPlaceholderColor() {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: self.wnPlaceholderColor ?? .lightGray])
    }
    
    private func addBorder() {
        self.layer.borderWidth = self.wnBorderWidth
        self.layer.borderColor = self.wnInactiveBorderColor?.cgColor
        self.layer.cornerRadius = self.wnCornerRadius
    }
    
    private func addLeftView() {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: self.leftViewWidth, height: self.frame.height))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.leftImageSize, height: self.leftImageSize))
        imageView.center = leftView.center
        imageView.image = self.leftImage
        imageView.contentMode = .scaleAspectFit
        leftView.addSubview(imageView)
        self.leftView = leftView
        self.leftViewMode = .always
    }
    
    private func addRightView() {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: self.rightViewWidth, height: self.frame.height))

        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: self.rightViewWidth, height: self.rightViewWidth)
        button.imageView?.contentMode = .scaleAspectFit
        button.center = rightView.center
        button.setImage(self.showPasswordImage, for: .normal)
        button.setImage(self.hidePasswordImage, for: .selected)
        button.addTarget(self, action: #selector(rightViewButtonAction), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        rightView.addSubview(button)
        self.rightView = rightView
        self.rightViewMode = .always
    }
    
    @objc private func rightViewButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !sender.isSelected
    }
}

// MARK: TEXTFIELD DELEGATE
extension WNPasswordTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.layer.borderColor = self.wnActiveBorderColor?.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.layer.borderColor = self.wnInactiveBorderColor?.cgColor
    }
}


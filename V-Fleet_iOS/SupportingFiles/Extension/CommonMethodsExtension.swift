//
//  CommonMethodsExtension.swift
//  Social Sense App
//
//  Created by ashish mehta on 17/08/22.
//

import UIKit

extension UIViewController {
    //MARK:- PUSH/POP METHODS
    func moveToNext(_ identifier: String, isAnimate: Bool, valueStr: String = "", storyboardIdentifier: String = "") {
        if storyboardIdentifier.isEmpty {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: identifier)
            controller?.title = valueStr
            navigationController?.pushViewController(controller!, animated: isAnimate)
        } else {
            let storyboard = UIStoryboard.init(name: storyboardIdentifier, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: identifier)
            controller.title = valueStr
            navigationController?.pushViewController(controller, animated: isAnimate)
        }
    }
    
    func popToBack(_ isAnimate: Bool) {
        navigationController?.popViewController(animated: isAnimate)
    }
    
    //MARK:- SHOW ALERT METHOD
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
                                                    message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- PRESENT/DISMISS METHODS
    func moveToPresent(_ identifier: String, isAnimate: Bool, valueStr: String = "", storyboardIdentifier: String = "") {
        if storyboardIdentifier.isEmpty {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: identifier)
            controller?.title = valueStr
            present(controller!, animated: isAnimate, completion: nil)
        } else {
            let storyboard = UIStoryboard.init(name: storyboardIdentifier, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: identifier)
            controller.title = valueStr
            present(controller, animated: isAnimate, completion: nil)
        }
    }
    
    func closeTo(_ isAnimate: Bool) {
        dismiss(animated: isAnimate)
    }
}

protocol NameDescribable {
    var typeName: String { get }
    static var typeName: String { get }
}

extension UIViewController {
    var typeName: String {
        return String(describing: type(of: self))
    }

    static var typeName: String {
        return String(describing: self)
    }
}
extension UILabel {

    // Pass value for any one of both parameters and see result
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
}

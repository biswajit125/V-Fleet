//
//  UIViewController+Extension.swift
//  Whetness
//
//  Created by Kamaljeet Punia on 23/03/21.
//  Copyright © 2021 Kamaljeet Punia. All rights reserved.
//

import UIKit

extension UIViewController {
    func addChildVC(_ child: UIViewController, toContainerView containerView: UIView) {
        containerView.removeSubviews()
        addChild(child)
        Utility.addEqualConstraints(for: child.view, inSuperView: containerView)
        child.didMove(toParent: self)
    }

    
    //Navigate using identifier
    
    func moveToNext(_ identifier : String , title : String = ""  ,  storyBoard : UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)){
        let objVC = storyBoard.instantiateViewController(withIdentifier: identifier)
        objVC.title = title
        navigationController?.pushViewController(objVC)
    }
    
    func popToBack(){
        navigationController?.popViewController()
    }
    
}
extension UIStoryboard {
    static func loadFromStoryboard(_ identifier: String, storyboard: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
}

extension UIViewController {

    func centerX(of tabItemIndex: Int) -> CGFloat? {
        guard let tabBarItemCount = tabBarController?.tabBar.items?.count else { return nil }
        let view = UIView(frame: CGRect(x: 100, y: (tabBarController?.tabBar.bounds.minY)! - 30 , width: (tabBarController?.tabBar.bounds.width)! - 60, height: (tabBarController?.tabBar.bounds.height)! + 20)) 
        let itemWidth = view.bounds.width / CGFloat(tabBarItemCount)
        return itemWidth * CGFloat(tabItemIndex + 1) - itemWidth / 2
    }
}

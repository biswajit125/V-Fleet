//
//  RoundedTabBarController.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 23/07/24.
//

import UIKit
//class RoundedTabbarController: UITabBarController, UITabBarControllerDelegate {
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//       //hideTabBarItems(at: [0, 1])
//    }
//    
//    func hideTabBarItems(at indices: [Int]) {
//        guard var viewControllers = self.viewControllers else { return }
//        let sortedIndices = indices.sorted(by: >)
//        for index in sortedIndices {
//            guard index < viewControllers.count else { continue }
//            viewControllers.remove(at: index)
//        }
//        self.viewControllers = viewControllers
//    }
//}

//import UIKit
//
//class RoundedTabbarController: UITabBarController, UITabBarControllerDelegate {
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.delegate = self
//        setupTabBarAppearance()
//       hideTabBarItems(at: [0, 1])
//    }
//    
//    private func handleAPIResponse() {
//        AppCache.shared.currentUser?.data?.access?.fleet
//        AppCache.shared.currentUser?.data?.access?.fuel
//        AppCache.shared.currentUser?.data?.access?.fuel
//    }
//    
//    func hideTabBarItems(at indices: [Int]) {
//        guard var viewControllers = self.viewControllers else { return }
//        let sortedIndices = indices.sorted(by: >)
//        for index in sortedIndices {
//            guard index < viewControllers.count else { continue }
//            viewControllers.remove(at: index)
//        }
//        self.viewControllers = viewControllers
//    }
//    
//    private func setupTabBarAppearance() {
//        // Example for setting up the first tab
//        if let firstTabBarItem = self.tabBar.items?[0] {
//            firstTabBarItem.image = UIImage(named: "ic_Attandance")?.withRenderingMode(.alwaysOriginal)
//            firstTabBarItem.selectedImage = UIImage(named: "ic_AttandanceClick")?.withRenderingMode(.alwaysOriginal)
//        }
//        
//        // Example for setting up the second tab
//        if let secondTabBarItem = self.tabBar.items?[1] {
//            secondTabBarItem.image = UIImage(named: "ic_fuel")?.withRenderingMode(.alwaysOriginal)
//            secondTabBarItem.selectedImage = UIImage(named: "ic_fuelClick")?.withRenderingMode(.alwaysOriginal)
//        }
//        
//        if let secondTabBarItem = self.tabBar.items?[2] {
//            secondTabBarItem.image = UIImage(named: "ic_Expense")?.withRenderingMode(.alwaysOriginal)
//            secondTabBarItem.selectedImage = UIImage(named: "ic_ExpenseClick")?.withRenderingMode(.alwaysOriginal)
//        }
//        
//        // Set font color for unselected state
//        let unselectedAttributes: [NSAttributedString.Key: Any] = [
//            .foregroundColor: UIColor.lightGray,
//            .font: UIFont.systemFont(ofSize: 12)
//        ]
//        
//        // Set font color for selected state
//        let selectedAttributes: [NSAttributedString.Key: Any] = [
//            .foregroundColor: UIColor.black,
//            .font: UIFont.systemFont(ofSize: 12)
//        ]
//        
//        UITabBarItem.appearance().setTitleTextAttributes(unselectedAttributes, for: .normal)
//        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
//    }
//}


//import UIKit

class RoundedTabbarController: UITabBarController, UITabBarControllerDelegate {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabBarAppearance()
        handleAPIResponse()
    }
    
    private func handleAPIResponse() {
        
        var indicesToHide = [Int]()
        
        if !(AppCache.shared.currentUser?.data?.access?.fleet ?? false) {
            indicesToHide.append(0)
        }
        
        if !(AppCache.shared.currentUser?.data?.access?.fuel ?? false) {
            indicesToHide.append(1)
        }
        
        if !(AppCache.shared.currentUser?.data?.access?.expense ?? false) {
            indicesToHide.append(2)
        }
        
        hideTabBarItems(at: indicesToHide)
    }
    
    func hideTabBarItems(at indices: [Int]) {
        guard var viewControllers = self.viewControllers else { return }
        let sortedIndices = indices.sorted(by: >)
        for index in sortedIndices {
            guard index < viewControllers.count else { continue }
            viewControllers.remove(at: index)
        }
        self.viewControllers = viewControllers
    }
    
    private func setupTabBarAppearance() {
        // Example for setting up the first tab
        if let firstTabBarItem = self.tabBar.items?[0] {
            firstTabBarItem.image = UIImage(named: "ic_Attandance")?.withRenderingMode(.alwaysOriginal)
            firstTabBarItem.selectedImage = UIImage(named: "ic_AttandanceClick")?.withRenderingMode(.alwaysOriginal)
        }
        
        // Example for setting up the second tab
        if let secondTabBarItem = self.tabBar.items?[1] {
            secondTabBarItem.image = UIImage(named: "ic_fuel")?.withRenderingMode(.alwaysOriginal)
            secondTabBarItem.selectedImage = UIImage(named: "ic_fuelClick")?.withRenderingMode(.alwaysOriginal)
        }
        
        if let thirdTabBarItem = self.tabBar.items?[2] {
            thirdTabBarItem.image = UIImage(named: "ic_Expense")?.withRenderingMode(.alwaysOriginal)
            thirdTabBarItem.selectedImage = UIImage(named: "ic_ExpenseClick")?.withRenderingMode(.alwaysOriginal)
        }
        
        // Set font color for unselected state
        let unselectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 12)
        ]
        
        // Set font color for selected state
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 12)
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(unselectedAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}

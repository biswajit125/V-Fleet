//
//  SelectedTimeSloteCVC.swift
//  PocketITNerd
//
//  Created by iTechDev1 on 21/10/22.
//

import UIKit

class SelectedTimeSloteCVC: UICollectionViewCell {
    //MARK: - @IBOutlet
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var mainVw: UIView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected { // Selected cell
                self.mainVw.backgroundColor = AppColor.timeSloteVw
                self.backgroundColor = AppColor.boldLabel
                self.lblTime?.textColor =  AppColor.timeSlotelbl
            } else { // Normal cell
                self.backgroundColor = #colorLiteral(red: 0.9490197301, green: 0.9490197301, blue: 0.9490197301, alpha: 1)
                self.lblTime?.textColor = .black
            }
        }
    }
}

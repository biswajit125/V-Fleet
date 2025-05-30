//
//  NotificationTVC.swift
//  Screen42
//
//  Created by ashish mehta on 22/06/22.
//

import UIKit

class NotificationTVC: UITableViewCell {
    
    //MARK: - @IBOutlet
    @IBOutlet var lblNotificatioMessage: UILabel!
    @IBOutlet var lblNotificationTime: UILabel!
    @IBOutlet weak var vWRed: UIView!
    @IBOutlet weak var vWBg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//
//  ProfileTVC.swift
//  PocketITNerd
//
//  Created by iTechDev1 on 13/10/22.
//

import UIKit

class ProfileTVC: UITableViewCell {
    //MARK: - @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContant: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    //MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

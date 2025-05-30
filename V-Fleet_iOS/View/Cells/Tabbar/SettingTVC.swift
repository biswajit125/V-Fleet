//
//  SettingTVC.swift
//  PocketITNerd
//
//  Created by iTechDev1 on 14/10/22.
//

import UIKit

class SettingTVC: UITableViewCell {
    //MARK: - @IBOutlet
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSwitch: UIButton!
    
    //binitRemember 1:-(Find indexpath in tableView)
    var switchHandler:(()->())?
    
    //MARK: - Variable
    //MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnSwitch.isSelected = UserDefaults.standard.bool(forKey: "onClickSwitch")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func tappedSwitch(_ sender: UIButton) {
        //binitRemember 2:-(Find indexpath in tableView)
        switchHandler?()
    }
    
}

//
//  PlansTVC.swift
//  PocketITNerd
//
//  Created by iTechDev1 on 13/10/22.
//

import UIKit

class PlansTVC: UITableViewCell {
    
    //MARK: @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblCase: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

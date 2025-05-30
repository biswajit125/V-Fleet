//
//  AttendanceHistoryTVC.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 19/07/24.
//

import UIKit

class AttendanceHistoryTVC: UITableViewCell {

    @IBOutlet weak var lblVehicleNumber: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStopTime: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

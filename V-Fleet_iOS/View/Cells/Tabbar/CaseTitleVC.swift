//
//  CaseTitleVC.swift
//  PocketITNerd
//
//  Created by Prashant Kumar on 17/10/22.
//

import UIKit

struct CaseTitleData {
    let image: UIImage
}

class CaseTitleVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var collVwCaseTitle: UICollectionView!
    @IBOutlet weak var stackVw: UIStackView!
    @IBOutlet weak var imgTimeHour: UIImageView!
    @IBOutlet weak var lblTimeHour: UILabel!
    
    //MARK: - VARIABLES
    var imgArray = [CaseTitleData(image: UIImage(named: "img") ?? UIImage()),
                    CaseTitleData(image: UIImage(named: "img") ?? UIImage()),
                    CaseTitleData(image: UIImage(named: "img") ?? UIImage()),
                    CaseTitleData(image: UIImage(named: "img") ?? UIImage()),
                    CaseTitleData(image: UIImage(named: "img") ?? UIImage()),
                    CaseTitleData(image: UIImage(named: "img") ?? UIImage()),
                    CaseTitleData(image: UIImage(named: "img") ?? UIImage()),
                    CaseTitleData(image: UIImage(named: "img") ?? UIImage())]
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        stackVw.isHidden = false
        lblTimeHour.isHidden = false
        imgTimeHour.isHidden = false
        imgTimeHour.isHidden = false
        if title == "0" //First
        {
            stackVw.isHidden = true
            lblTimeHour.isHidden = true
            imgTimeHour.isHidden = true
        }
        else if title == "1" //Second
        {
        }else if title == "2" //Third
        {
        }
    }
    //MARK: - @IBAction
    @IBAction func actionBack(_ sender: UIButton) {
        popToBack()
    }
}

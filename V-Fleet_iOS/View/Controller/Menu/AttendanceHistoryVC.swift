//
//  AttendanceHistoryVC.swift
//  V-Fleet_iOS
//
//  Created by Bishwajit Kumar on 19/07/24.
//

import UIKit

class AttendanceHistoryVC: UIViewController {
    
    @IBOutlet weak var tblAttandance: UITableView!
    @IBOutlet weak var lblTitlename: UILabel!
    
    let viewModel = AttendanceHistoryVM()
    var userId = AppCache.shared.currentUser?.data?.id ?? 0
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        tblAttandance.register(UINib(nibName: "AttendanceHistoryTVC", bundle: nil), forCellReuseIdentifier: "AttendanceHistoryTVC")
        self.lblTitlename.text = AppCache.shared.currentUser?.data?.name

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tblAttandance.layer.cornerRadius = 20
        tblAttandance.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        getAttendanceReportByUser(userId: self.userId)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        popToBack()
    }
    

}
//MARK: - TableView Delegates
extension AttendanceHistoryVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.responseModel?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendanceHistoryTVC", for: indexPath)as!  AttendanceHistoryTVC
        let data = viewModel.responseModel?.data
        
        cell.lblDriverName.text = data?[indexPath.row].driverName
        cell.lblDate.text = data?[indexPath.row].date
        cell.lblStartTime.text = data?[indexPath.row].startTime
        cell.lblStopTime.text = data?[indexPath.row].startTime
        cell.lblTotalTime.text = data?[indexPath.row].totalHours
        cell.lblDriverName.text = data?[indexPath.row].driverName
        
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
}
//MARK: - API METHODS
extension AttendanceHistoryVC {
    func getAttendanceReportByUser(userId: Int) {
        CustomLoader.shared.show()
        viewModel.getAttendanceReportByUser(userId: userId) { [weak self] (result) in
            CustomLoader.shared.hide()
            switch result {
            case .success(let response):
                print(response.status)
                DispatchQueue.main.async {
                    self?.tblAttandance.reloadData()
                }
                

            case .failure(let error):
                self?.showAlert(title: AlertsNames.error.rawValue, message: error.message)
            }
        }
    }
}

//
//  CustomPickerView.swift
//  TimeApp
//
//  Created by Kamaljeet Punia on 06/05/20.
//  Copyright © 2020 Tina. All rights reserved.
//

import UIKit

// Usage:
// CustomPickerView.show(items: items, itemIds: ids, selectedValue: nil) { (selectedItem, selectedId) in
// }

class CustomPickerView: NSObject {

    //Theme colors
    var itemTextColor = UIColor.black
    var backgroundColor = #colorLiteral(red: 0.6666070223, green: 0.6667048931, blue: 0.6665855646, alpha: 1)
    var toolBarColor = #colorLiteral(red: 0.9678314328, green: 0.9649544358, blue: 0.9647228122, alpha: 1)
    var buttonTextColor = #colorLiteral(red: 0, green: 0.2745098039, blue: 1, alpha: 1)
    var font = UIFont.systemFont(ofSize: 17, weight: .medium)

    private static var shared:CustomPickerView!
    var bottomAnchorOfPickerView:NSLayoutConstraint!
    var heightOfPickerView:CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 210 : 170
    var heightOfToolbar:CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 55 : 45

    var dataSource:(items:[String]?,itemIds:[String]?)

    typealias CompletionBlock = (_ item:String?,_ id:String?) -> Void
    var didSelectCompletion:CompletionBlock?
    var doneBottonCompletion:CompletionBlock?
    var cancelBottonCompletion:CompletionBlock?


    lazy var pickerView:UIPickerView={
        let pv = UIPickerView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.delegate = self
        pv.dataSource = self
       // pv.showsSelectionIndicator = true
        pv.backgroundColor = self.backgroundColor
        return pv
    }()

    lazy var disablerView:UIView={
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()

    lazy var tooBar:UIView={
        let view = UIView()
        view.backgroundColor = self.toolBarColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = self.backgroundColor.withAlphaComponent(0.7)
        view.addSubview(line)
        line.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true

        view.addSubview(buttonDone)
        buttonDone.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        buttonDone.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        buttonDone.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        buttonDone.widthAnchor.constraint(equalToConstant: 65).isActive = true

        view.addSubview(buttonCancel)
        buttonCancel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        buttonCancel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        buttonCancel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        buttonCancel.widthAnchor.constraint(equalToConstant: 65).isActive = true

        return view
    }()


    lazy var buttonDone:UIButton={
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.tintColor = buttonTextColor
        button.titleLabel?.font = self.font
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(self.buttonDoneClicked), for: .touchUpInside)
        return button
    }()

    lazy var buttonCancel:UIButton={
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.tintColor = buttonTextColor
        button.titleLabel?.font = self.font
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(self.buttonCancelClicked), for: .touchUpInside)
        return button
    }()


    static func show(items:[String],itemIds:[String]? = nil,selectedValue:String? = nil,doneBottonCompletion:CompletionBlock?/*,didSelectCompletion:CompletionBlock?,cancelBottonCompletion:CompletionBlock?*/){

        if CustomPickerView.shared == nil{
            shared = CustomPickerView()
        }else{
            return
        }

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,let keyWindow = appDelegate.window {

            //shared.cancelBottonCompletion = cancelBottonCompletion
            //shared.didSelectCompletion = didSelectCompletion
            shared.doneBottonCompletion = doneBottonCompletion
            shared.dataSource.items = items

            if let idsVal = itemIds,items.count == idsVal.count{ //ids can not be less or more than items
                shared?.dataSource.itemIds  = itemIds
            }

            shared?.heightOfPickerView += shared.heightOfToolbar

            keyWindow.addSubview(shared.disablerView)
            shared.disablerView.leftAnchor.constraint(equalTo: keyWindow.leftAnchor, constant: 0).isActive = true
            shared.disablerView.rightAnchor.constraint(equalTo: keyWindow.rightAnchor, constant: 0).isActive = true
            shared.disablerView.topAnchor.constraint(equalTo: keyWindow.topAnchor, constant: 0).isActive = true
            shared.disablerView.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor, constant: 0).isActive = true


            shared.disablerView.addSubview(shared.pickerView)
            shared.pickerView.leftAnchor.constraint(equalTo: shared.disablerView.leftAnchor, constant: 0).isActive = true
            shared.pickerView.rightAnchor.constraint(equalTo: shared.disablerView.rightAnchor, constant: 0).isActive = true
            shared.pickerView.heightAnchor.constraint(equalToConstant: shared.heightOfPickerView).isActive = true
            shared.bottomAnchorOfPickerView = shared.pickerView.topAnchor.constraint(equalTo: shared.disablerView.bottomAnchor, constant: 0)
            shared.bottomAnchorOfPickerView.isActive = true


            shared.disablerView.addSubview(shared.tooBar)
            shared.tooBar.heightAnchor.constraint(equalToConstant: shared.heightOfToolbar).isActive = true
            shared.tooBar.leftAnchor.constraint(equalTo: shared.disablerView.leftAnchor, constant: 0).isActive = true
            shared.tooBar.rightAnchor.constraint(equalTo: shared.disablerView.rightAnchor, constant: 0).isActive = true
            shared.tooBar.bottomAnchor.constraint(equalTo: shared.pickerView.topAnchor, constant: 0).isActive = true

            keyWindow.layoutIfNeeded()


            if let selectedVal = selectedValue{
                for (index,itemName) in items.enumerated(){
                    if itemName.lowercased() == selectedVal.lowercased(){
                        shared.pickerView.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                }
            }

            shared.bottomAnchorOfPickerView.constant = -shared.heightOfPickerView

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                keyWindow.layoutIfNeeded()
                shared.disablerView.alpha = 1
            }) { (bool) in  }

        }
    }

    @objc private func buttonDoneClicked(){
        self.hidePicker(handler: doneBottonCompletion)
    }

    @objc private func buttonCancelClicked(){

        self.hidePicker(handler: cancelBottonCompletion)
    }

    private func hidePicker(handler:CompletionBlock?){
        var itemName:String?
        var id:String?
        let row = self.pickerView.selectedRow(inComponent: 0)
        if let names = dataSource.items{
            if names.count > row {
                itemName = names[row]
            }
        }
        if let ids = dataSource.itemIds{
            if ids.count > row {
            id = ids[row]
            }
        }
        handler?(itemName, id)

        bottomAnchorOfPickerView.constant = self.heightOfPickerView
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.disablerView.window!.layoutIfNeeded()
            self.disablerView.alpha = 0
        }) { (bool) in
            self.disablerView.removeFromSuperview()
            CustomPickerView.shared = nil
        }
    }

}

// MARK: - PICKER VIEW DATA SOURCE
extension CustomPickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let count = dataSource.items?.count{
            return count
        }
        return 0
    }

}

// MARK: - PICKER VIEW DELEGATE
extension CustomPickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if let names = dataSource.items{
            return names[row]
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if let names = dataSource.items{
            let item = names[row]
            return NSAttributedString(string: item, attributes: [NSAttributedString.Key.foregroundColor : itemTextColor,NSAttributedString.Key.font : font])
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var itemName:String?
        var id:String?

        if let names = dataSource.items{
            itemName = names[row]
        }
        if let ids = dataSource.itemIds{
            id = ids[row]
        }
        self.didSelectCompletion?(itemName, id)
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
}

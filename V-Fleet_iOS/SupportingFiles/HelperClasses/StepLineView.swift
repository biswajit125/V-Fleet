//
//  StepLineView.swift
//  Whetness
//
//  Created by Kamaljeet Punia on 23/03/21.
//  Copyright © 2021 Kamaljeet Punia. All rights reserved.
//

import UIKit

enum StepLineState {
    case pending
    case active
}

class StepLineView: UIView {
    
    // MARK: - VARIABLES
    var currentState: StepLineState = .pending {
        didSet {
            self.setBgColorForState(self.currentState)
        }
    }
    private var colorsDictionary = [StepLineState: UIColor]()
    
    ///Inspectable properties
    @IBInspectable var pendingStateColor: UIColor? {
        didSet {
            self.colorsDictionary[.pending] = self.pendingStateColor
            self.backgroundColor = self.pendingStateColor
        }
    }
    
    @IBInspectable var activeStateColor: UIColor? {
        didSet {
            self.colorsDictionary[.active] = self.activeStateColor
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setBgColorForState(_ state: StepLineState) {
        if let color = self.colorsDictionary[state] {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.backgroundColor = color
            }
        }
    }
}


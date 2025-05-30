//
//  StepButton.swift
//  Whetness
//
//  Created by Kamaljeet Punia on 23/03/21.
//  Copyright © 2021 Kamaljeet Punia. All rights reserved.
//

import UIKit

enum StepButtonState {
    case pending
    case active
    case completed
}

class StepButton: UIButton {
    
    // MARK: - VARIABLES
    var currentState: StepButtonState = .pending {
        didSet {
            self.setImageForState(self.currentState)
        }
    }
    private var imagesDictionary = [StepButtonState: UIImage]()
    
    ///Inspectable properties
    @IBInspectable var pendingStateImage: UIImage? {
        didSet {
            self.imagesDictionary[.pending] = self.pendingStateImage
            self.setImage(self.pendingStateImage, for: .normal)
        }
    }
    
    @IBInspectable var activeStateImage: UIImage? {
        didSet {
            self.imagesDictionary[.active] = self.activeStateImage
        }
    }
    
    @IBInspectable var completedStateImage: UIImage? {
        didSet {
            self.imagesDictionary[.completed] = self.completedStateImage
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setImageForState(_ state: StepButtonState) {
        if let image = self.imagesDictionary[state] {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.setBackgroundImage(image, for: .normal)
            }
        }
    }
}

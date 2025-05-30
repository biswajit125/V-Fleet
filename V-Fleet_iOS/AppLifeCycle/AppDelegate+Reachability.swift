//
//  AppDelegate+Reachability.swift
//  Whetness
//
//  Created by Kamaljeet Punia on 23/09/20.
//  Copyright © 2020 Kamaljeet Punia. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    var redColorForNetwork: UIColor {
        return UIColor(red: 220, green: 20, blue: 60, alpha: 1) ?? .gray
    }
    var greenColorForNetwork: UIColor {
        return UIColor(red: 46, green: 139, blue: 87, alpha: 1) ?? .gray
    }
    
    func initializeReachability() {
        self.setupNetworkAlertLabel()
        self.addReachabilityObserver()
        
        do {
            try Network.reachability = Reachability(hostname: "www.google.com")
        }
        catch {
            switch error as? Network.Error {
            case let .failedToCreateWith(hostname)?:
                Logger.printLog(.error, "Network error:\nFailed to create reachability object With host named: \(hostname)")
            case let .failedToInitializeWith(address)?:
                Logger.printLog(.error, "Network error:\nFailed to initialize reachability object With address: \(address)")
            case .failedToSetCallout?:
                Logger.printLog(.error, "Network error:\nFailed to set callout")
            case .failedToSetDispatchQueue?:
                Logger.printLog(.error, "Network error:\nFailed to set DispatchQueue")
            case .none:
                Logger.printLog(.error, error.localizedDescription)
            }
        }
    }
    
    private func addReachabilityObserver() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: nil)
    }
    
    @objc private func statusManager(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.setupReachabilityAlert()
        }
    }
    
    private func setupReachabilityAlert() {
        
        if Network.reachability.isReachable {
            self.networkAlertLabel?.backgroundColor = self.greenColorForNetwork
            self.networkAlertLabel?.text = "Network is reachable"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.networkAlertLabel?.removeFromSuperViewWithAnimation()
            }
        }else {
            self.networkAlertLabel?.backgroundColor = self.redColorForNetwork
            self.networkAlertLabel?.text = "Network not reachable"
            
            if let label = self.networkAlertLabel {
                UIApplication.shared.keyWindow?.addSubviewWithAnimation(label)
            }
        }
    }
    
    private func setupNetworkAlertLabel() {
        self.networkAlertLabel = UILabel()
        self.networkAlertLabel?.frame.size.width = UIScreen.main.bounds.size.width
        self.networkAlertLabel?.frame.size.height = 100
        self.networkAlertLabel?.textColor = .white
        self.networkAlertLabel?.textAlignment = .center
        self.networkAlertLabel?.font = AppFont.bold.fontWithSize(17)
    }
}

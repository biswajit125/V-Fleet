//
//  CustomZoomImageView.swift
//  AduroExpress
//
//  Created by yapapp on 3/6/20.
//  Copyright © 2020 TG. All rights reserved.
//

import UIKit

class CustomZoomImageView: UIImageView {
    
    // MARK: - VARIABLES
    var fullScreenImageView: UIImageView?
    var scrollView: UIScrollView?
    var indexPath: IndexPath?
    var customImageVC: CustomZoomImageVC?
    var imageURLString: String?
    
    // MARK: - INITIALIZERS
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupTapGesture()
    }

    // MARK: - PRIVATE FUNCTIONS
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    
    @objc func handleTapGesture(gesture: UITapGestureRecognizer) {
        if self.image == nil { return }
        if let topVC = UIApplication.topVC() {
            self.setupFullScreenImageView(with: topVC)
        }
    }
    
    private func setupFullScreenImageView(with vc: UIViewController) {
        
        self.fullScreenImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        self.fullScreenImageView?.center = vc.view.center
        self.fullScreenImageView?.isUserInteractionEnabled = true
        self.fullScreenImageView?.backgroundColor = .black
        self.fullScreenImageView?.image = self.image
        self.fullScreenImageView?.contentMode = .scaleAspectFit
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeGesture.direction = .down
        self.fullScreenImageView?.addGestureRecognizer(swipeGesture)
        
        self.scrollView = UIScrollView(frame: self.fullScreenImageView!.bounds)
        self.scrollView?.addSubview(self.fullScreenImageView!)
        self.scrollView?.minimumZoomScale = 1.0
        self.scrollView?.maximumZoomScale = 6.0
        self.scrollView?.delegate = self
        self.scrollView?.bouncesZoom = false
        self.scrollView?.bounces = false
        
        self.customImageVC = CustomZoomImageVC()
        self.customImageVC?.view.addSubview(self.scrollView!)
        self.customImageVC?.modalPresentationStyle = .overFullScreen
        self.customImageVC?.view.alpha = 1
        
        self.addCloseButton()

        vc.present(self.customImageVC!, animated: false, completion: { [weak self] in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                self?.scrollView?.frame = UIScreen.main.bounds
                self?.fullScreenImageView?.frame = UIScreen.main.bounds
            }, completion: {[weak self] finish in
                //
            })
        })
    }
    
    @objc func handleSwipeGesture(gesture: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.scrollView?.frame.origin.y = 300
            self?.customImageVC?.view.alpha = 0
        }) { [weak self] finish in
            self?.customImageVC?.dismiss(animated: false, completion: nil)
        }
    }
    
    private func addCloseButton() {
        let xPosition = UIScreen.main.bounds.width - 60
        let topSafeArea = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 20.0
        let crossButton = UIButton(frame: CGRect(x: xPosition, y: topSafeArea, width: 55, height: 46))
        let crossImageView = UIImageView(frame: CGRect(x: 18, y: 5, width: 24, height: 24))
        crossImageView.image = #imageLiteral(resourceName: "crossBlack")
        crossImageView.backgroundColor = .white
        crossImageView.layer.cornerRadius = crossImageView.frame.size.width / 2
        crossImageView.layer.masksToBounds = true
        crossButton.addSubview(crossImageView)
        crossButton.addTarget(self, action: #selector(handleSwipeGesture), for: .touchUpInside)
        self.customImageVC?.view.addSubview(crossButton)
    }
}

// MARK: - SCROLL VIEW DELEGATE
extension CustomZoomImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.fullScreenImageView
    }
}


class CustomZoomImageVC: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.statusBar
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
    }
}

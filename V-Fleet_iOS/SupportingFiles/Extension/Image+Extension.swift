//
//  Image+Extension.swift
//  TimeApp
//
//  Created by Kamaljeet Punia on 11/06/20.
//  Copyright © 2020 Tina. All rights reserved.
//


//extension UIImageView {
//    /// Download and show the image on image view from the given URL.
//    func setImageWithKF(_ imageURLString: String?, placeHolder: UIImage? = nil, completion: ((UIImage?) -> ())? = nil) {
//        if let imageURL = imageURLString,
//           let url = URL(string: imageURL) {
//            let resource = ImageResource(downloadURL: url)
//            kf.indicatorType = .activity
//            kf.setImage(with: resource, placeholder: placeHolder ?? UIImage(named: "dummy-user"), options: [.transition(.fade(1)), .cacheOriginalImage], completionHandler: { result in
//                switch result {
//                case .success(let imageResult):
//                    completion?(imageResult.image)
//                case .failure(let error):
//                    debugPrint(error.localizedDescription)
//                    completion?(nil)
//                }
//            })
//        } else {
//            completion?(nil)
//        }
//    }
//    
//    /// Firstly download & show the thumbnail on image view from the given thumbnail URL string. After that, automatically download & show the image from the image URL string.
//    func setImageWith(thumbnailUrlString: String?, imageUrlString: String?, completion: ((Bool) -> ())? = nil) {
//        if let urlString = thumbnailUrlString, !urlString.isEmpty, let url = URL(string: urlString) {
//            let resource = ImageResource(downloadURL: url)
//            kf.indicatorType = .activity
//            kf.setImage(with: resource, placeholder: UIImage(named: "img_bodyGuard"), options: [.transition(.fade(1)), .cacheOriginalImage]) { [weak self] result in
//                switch result {
//                case .success(_):
//                    if let imageUrlString = imageUrlString, !imageUrlString.isEmpty {
//                        self?.getFullImageAndSet(with: imageUrlString) { image in
//                            completion?(true)
//                        }
//                    } else {
//                        completion?(true)
//                    }
//                case .failure(_):
//                    completion?(false)
//                }
//            }
//        } else if let imageUrlString = imageUrlString, !imageUrlString.isEmpty {
//            getFullImageAndSet(with: imageUrlString) { image in
//                completion?(true)
//            }
//        } else {
//            completion?(false)
//        }
//    }
//    
//    private func getFullImageAndSet(with urlString: String, completion: @escaping (UIImage?) -> ()) {
//        if urlString.isEmpty {
//            return
//        }
//        
//        guard let url = URL(string: urlString) else {
//            return
//        }
//        let resource = ImageResource(downloadURL: url)
//        let tempImageView = UIImageView()
//        tempImageView.kf.setImage(with: resource, options: [.cacheOriginalImage]) { result in
//            switch result {
//            case .success(_):
//                completion(tempImageView.image)
//                if let image = tempImageView.image {
//                    UIView.transition(with: self, duration: 0.50, options: .transitionCrossDissolve, animations: {
//                        self.image = image
//                    }, completion: nil)
//                }
//            case .failure(_):
//                completion(nil)
//            }
//        }
//    }
//}

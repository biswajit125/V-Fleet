//
//  LocationManager.swift
//   LaundryPickup
//
//  Created by Chitra on 18/05/21.
//
//
//  LocationManager.swift
//   LaundryPickup
//
//  Created by Chitra on 18/05/21.
//

import CoreLocation
import UIKit

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    var manager = CLLocationManager()
    var completion: ((Bool, CLAuthorizationStatus?) -> ())?
    var locationShared = CLLocation()
    
    
    
    // - API
    public var exposedLocation: CLLocation? {
        return self.manager.location
    }
    
    private override init() {
        super.init()
        //        DispatchQueue.main.async {
        //            self.manager = CLLocationManager()
        //        }
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
        
        
    }
    
    func checkLocationAuthorization(completion: ((Bool, CLAuthorizationStatus?) -> ())?) {
            self.completion = completion
            if CLLocationManager.locationServicesEnabled() {
                let status = manager.authorizationStatus // Use the property, not the deprecated method
                handleAuthorizationStatus(status)
            } else {
                debugPrint("Location services are not enabled")
                completion?(false, nil)
            }
        }
    
    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            debugPrint("No access")
            manager.requestWhenInUseAuthorization()
            
        case .denied:
            debugPrint("Access Denied >>>")
            completion?(false, .denied)
        
        case .restricted:
            debugPrint("Access restricted >>>")
            completion?(false, .restricted)
            
        case .authorizedAlways, .authorizedWhenInUse:
            debugPrint("Access")
            completion?(true, nil)
            self.completion = nil
            
        @unknown default:
            debugPrint("Unknown access")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        handleAuthorizationStatus(status) // Handle changes in authorization
    }
    
//    func checkLocationAuthorization(completion: ((Bool, CLAuthorizationStatus?) -> ())?) {
//        self.completion = completion
//        if CLLocationManager.locationServicesEnabled() {
//            switch CLLocationManager.authorizationStatus() {
//
//            case .notDetermined:
//                debugPrint("No access")
//                manager.requestWhenInUseAuthorization()
//
//            case .restricted, .denied:
//                debugPrint("Access Denied >>> ")
//                completion?(false, CLAuthorizationStatus.denied)
//
//            case .authorizedAlways, .authorizedWhenInUse:
//                debugPrint("Access")
//                self.completion?(true, nil)
//                self.completion = nil
//            @unknown default:
//                debugPrint("Unknown access")
//            }
//        } else {
//            debugPrint("Location services are not enabled")
//            self.completion?(false, nil)
//        }
//    }
    
    
    
    func startMonitoring() {
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
    }
    
    func stopMonitoring() {
        if CLLocationManager.locationServicesEnabled() {
            manager.stopUpdatingLocation()
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ name: String?,
                                                                               _ thoroughfare: String?, _ subThorough:  String?,
                                                                               _ locality: String?, _ subLocality:  String?,
                                                                               _ admin: String?, _ subAdmin:  String?, _ country:  String?, _ postalCode: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.name,
                       placemarks?.first?.thoroughfare,
                       placemarks?.first?.subThoroughfare,
                       placemarks?.first?.locality,
                       placemarks?.first?.subLocality, //district
                       placemarks?.first?.administrativeArea, //state
                       placemarks?.first?.subAdministrativeArea, //city
                       placemarks?.first?.country,
                       placemarks?.first?.postalCode,
                       error)
        }
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            debugPrint("User still thinking granting location access!")
            //manager.startUpdatingLocation() // this will access location automatically if user granted access manually. and will not show apple's request alert twice. (Tested)
            manager.requestWhenInUseAuthorization()
            self.completion?(false, CLAuthorizationStatus.notDetermined)
            break
            
        case .denied, .restricted:
            debugPrint("User denied location access request!!")
            //            manager.stopUpdatingLocation()
            self.completion?(false, CLAuthorizationStatus.denied)
            break
            
        case .authorizedWhenInUse:
            manager.startUpdatingLocation() //Will update +66 immediately
            self.completion?(true, CLAuthorizationStatus.authorizedWhenInUse)
            self.completion = nil
            break
            
        case .authorizedAlways:
            manager.startUpdatingLocation() //Will update location immediately
            self.completion?(true, CLAuthorizationStatus.authorizedAlways)
            self.completion = nil
            break
        default:
            self.completion?(false, nil)
            break
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        /*guard let location: CLLocation = manager.location else { return }
//        fetchCityAndCountry(from: location) { city, country, error in
//            guard let city = city, let country = country, error == nil else { return }
//            print(city + ", " + country)
//        }*/
//    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          guard let location: CLLocation = manager.location else { return         }
          locationShared = location
      }
    
    
}

// MARK: GET PLACE
extension LocationManager {
    
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
}

extension LocationManager {
    func openAppSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    }
    
    func showLocationPermissionAlert() {
        let alertController = UIAlertController(title: "Location Access Needed",
                                                message: "Please enable location access in settings to allow this feature.",
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
            self.openAppSettings()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        // Present the alert
        if let topController = UIApplication.shared.windows.first?.rootViewController {
            topController.present(alertController, animated: true, completion: nil)
        }
    }
}


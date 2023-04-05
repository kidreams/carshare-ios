//
//  CSLocationWorker.swift
//  CarShare
//
//  Created by nicholas on 3/26/23.
//

import UIKit
import CoreLocation

class CSLocationWorker: NSObject {
    static let shared: CSLocationWorker =
    {
        let instance = CSLocationWorker()
        /*
         Custom setup code
         */
        instance.setupLocationManager()
        return instance
    }()
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    fileprivate var locationAuthorizationDidChangeUpdater: ((CLAuthorizationStatus) -> Void)?
    
    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
    }
    
    func requestLocationAuthorization() {
        Task {
            if CLLocationManager.locationServicesEnabled() {
                let authorizationStatus = locationManager.authorizationStatus
                guard authorizationStatus == .notDetermined else { return }
                locationManager.delegate = self
                // Uncomment if AlwaysAuthorization is needed.
                //            locationAuthorizationDidChangeUpdater = { [weak self] (status) in
                //                if status == .authorizedWhenInUse { self?.locationManager.requestAlwaysAuthorization() }
                //            }
                locationManager.requestWhenInUseAuthorization()
            } else {
                // TODO: Do something for permission has been disabled.
            }
        }
    }
    
    func startUpdate(services: [CSLocationRealTimeServices] = [.location,
                                                               .heading]) {
        if (locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse) {
            if services.contains(.heading) { locationManager.startUpdatingHeading() }
            if services.contains(.location) { locationManager.startUpdatingLocation() }
        }
    }
    
    
    func stopUpdate(services: [CSLocationRealTimeServices] = [.location,
                                                              .heading]) {
        if services.contains(.heading) { locationManager.stopUpdatingHeading() }
        if services.contains(.location) { locationManager.stopUpdatingHeading() }
    }
}


extension CSLocationWorker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let latestStatus = manager.authorizationStatus
        locationAuthorizationDidChangeUpdater?(latestStatus)
    }
}


enum CSLocationRealTimeServices {
    case location
    case heading
}

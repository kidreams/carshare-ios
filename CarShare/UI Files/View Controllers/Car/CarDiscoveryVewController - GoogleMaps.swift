//
//  CarDiscoveryVewController - GoogleMaps.swift
//  CarShare
//
//  Created by nicholas on 3/26/23.
//

import UIKit
import GoogleMaps

extension CarDiscoveryViewController: GMSMapViewDelegate {
    
    func setupGoogleMaps() {
        
        var coordinate = defaultLocation
        
        if let latestCoordinate = CSLocationWorker.shared.locationManager.location?.coordinate {
            coordinate = latestCoordinate
        }
        let camera = GMSCameraPosition.camera(withTarget: coordinate,
                                              zoom: 15,
                                              bearing: 0,
                                              viewingAngle: 0)
        
        mapView.isIndoorEnabled = false
        mapView.isMyLocationEnabled = true
        mapView.camera = camera
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print(#function)
        carsUpdateDebouncer.call()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print(#function)
        if let _carID = marker.snippet,
            let carID = Int(_carID),
           let car = cars?.filter({ $0.carID == carID }).first {
         showCarPreview(car: car)
        }
        return true
    }
    
}

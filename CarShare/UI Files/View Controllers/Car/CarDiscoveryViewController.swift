//
//  CarDiscoveryViewController.swift
//  CarShare
//
//  Created by nicholas on 3/23/23.
//

import UIKit
import SwiftyJSON
import GoogleMaps
import GooglePlaces
import CoreLocation
import Repeat


class CarDiscoveryViewController: BaseViewController {
    
    var cars: [CSCarDetail]?
    var markers: [GMSMarker] = []
    var currentLocation: CLLocation?
    @IBOutlet weak var mapView: GMSMapView!
    
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    let defaultLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 22.318154177256243, longitude: 113.93534843016447)
    
    let carsUpdateDebouncer = Debouncer(.seconds(1))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLocationServices()
        setupGoogleMaps()
        
        carsUpdateDebouncer.callback = { [weak self] in
            self?.fetchCars(showLoading: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if cars == nil {
            fetchCars()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCars(showLoading: cars == nil)
    }
    
    func fetchCars(showLoading: Bool = true) {
        self.dismissWorker()
        let worker = CSAPIWorker(with: CSEndPoints.cars())?
            .prepare(indicator: showLoading)
            .when(success: { [weak self] (result) in
                self?.fetchComplete()
                let cars: [CSCarDetail] = result["data"].csModelArray()
                self?.update(cars: cars)
                self?.dismissWorker()
            })
            .when(failure: { [weak self] (error) in
                self?.fetchComplete()
                self?.dismissWorker()
            })
            .fire()
        
        self.apiWorker = worker
    }
    
    func fetchComplete() {
        
    }
    
    func setupLocationServices() {
        CSLocationWorker.shared.requestLocationAuthorization()
        CSLocationWorker.shared.startUpdate()
    }
    
    func update(cars: [CSCarDetail]) {
        self.cars = cars
        self.mapView.clear()
        self.refreshMarkers(with: cars)
    }
    
    func refreshMarkers(with cars: [CSCarDetail]) {
        
        let markers: [GMSMarker] = cars.compactMap({ [weak self] (car) in
            let position = CLLocationCoordinate2D(latitude: car.lat, longitude: car.long)
            let marker = GMSMarker(position: position)
            marker.snippet = String(car.carID)
            marker.icon = UIImage(named: "car-icon")?.mapMarker
            marker.map = self?.mapView
            return marker
        })
        self.markers = markers
    }
    
    func showCarPreview(car: CSCarDetail) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let previewPage: CarPreviewViewController = storyboard.instantiateViewController(identifier: "CarPreviewViewController")
        previewPage.carDetail = car
        previewPage.delegate = self
        previewPage.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(previewPage, animated: true)
    }

}


extension CarDiscoveryViewController: CarPreviewProtocol {
    func prepareReservation(for car: CSCarDetail) {
        self.navigationController?.presentedViewController?.dismiss(animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let reservationPage: ReservationViewController = storyboard.instantiateViewController(identifier: "ReservationViewController")
        reservationPage.carDetail = car
        self.navigationController?.pushViewController(reservationPage, animated: true)
    }
}

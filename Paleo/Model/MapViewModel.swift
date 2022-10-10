//
//  MapViewModel.swift
//  Paleo
//
//  Created by Joseph Zhu on 25/5/2022.
//

import MapKit
import SwiftUI

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}

//extension MKCoordinateSpan: Equatable {}
//
//public func ==(lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
//    return lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
//}
//
//extension MKCoordinateRegion: Equatable {}
//
//public func ==(lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
//    return lhs.center == rhs.center && lhs.span == rhs.span
//}

enum MapDetails {
    static let defaultLocation = CLLocationCoordinate2D(latitude:  -33.8688, longitude: 151.2093)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: MapDetails.defaultLocation,
        span: MapDetails.defaultSpan
    )
    @Published var isShowAlert: Bool = false
    var alertMessage: String = ""
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager?.delegate = self    //!
        } else {
            alertMessage = "Allow Location Access"
            isShowAlert = true
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            alertMessage = "Your location is restricted, possibly due to parental controls"
            isShowAlert = true
        case .denied:
            alertMessage = "You have denied this app location permission. Go into settings to change it."
            isShowAlert = true
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(
                center: locationManager.location?.coordinate ?? MapDetails.defaultLocation,
                span: MapDetails.defaultSpan)
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func requestAllowOnceLocationPermission() {
        //locationManager?.requestLocation()
        locationManager?.startUpdatingLocation()
        print("started")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            alertMessage = "Could not retrieve user location"
            isShowAlert = true
            return
        }
        locationManager?.stopUpdatingLocation()
        print("stopped")
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(
                center: latestLocation.coordinate,
                span: MapDetails.defaultSpan)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func changeLocation(coord: CLLocationCoordinate2D) {
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(
                center: coord,
                span: MapDetails.defaultSpan)
        }
    }
}

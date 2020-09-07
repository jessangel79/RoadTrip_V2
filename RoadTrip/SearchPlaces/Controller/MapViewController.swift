//
//  MapViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 07/09/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var changeMapTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var locateMeButton: UIButton!
    
    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    var cellule: PlacesSearchElement?
    var userPosition: CLLocation?
    
//    var latitudeInit: Double?
//    var longitudeInit: Double?
//    var coordinateInit: CLLocationCoordinate2D {
//        return CLLocationCoordinate2D(latitude: latitudeInit ?? 48.863581, longitude: longitudeInit ?? 2.344312)
//    }
        
    // MARK: - Actions
    
    @IBAction func changeMapTypeButtonTapped(_ sender: UISegmentedControl) {
        switch changeMapTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = MKMapType.standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            break
        }
    }
    
    @IBAction func getPosition(_ sender: UIButton) {
        print("getPosition")
//        setupMap(coordinates: userPosition?.coordinate ?? coordinateInit, myLat: latitudeInit ?? 48.863581, myLon: longitudeInit ?? 2.344312)
        
//        setupMap(coordinates: userPosition?.coordinate ?? CLLocationCoordinate2D(), myLat: 1, myLon: 1)
        
        if userPosition != nil {
            setupMap(coordinates: userPosition?.coordinate ?? CLLocationCoordinate2D(), myLat: 1, myLon: 1)
        } else {
            print("nil dans getPosition")
        }
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        customUI()
        
//        setupData()
        
        displayCelluleMap()
        setupLocationManager()
        
        // test
//        locationManagerFunc()

//        displayMap()
        
    }
    
    // MARK: - Methods
    
    private func customUI() {
        customButton(button: locateMeButton, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.7516320634), colorBorder: #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1))
    }
    
    // TODO
//    func setupData() {
//        guard let latitude = Double(cellule?.lat ?? "48.863581") else { return }
//        guard let longitude = Double(cellule?.lon ?? "2.344312") else { return }
//        guard let title = cellule?.displayName.cutEndString() else { return }
//        guard let subtitle = cellule?.displayName.cutStartString(2) else { return }
//        guard let info = cellule?.type else { return }
//    }
    
    func setupMap(coordinates: CLLocationCoordinate2D, myLat: Double, myLon: Double) {
        let span = MKCoordinateSpan(latitudeDelta: myLat, longitudeDelta: myLon)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func displayCelluleMap() {
        guard let latitude = Double(cellule?.lat ?? "48.863581") else { return }
        guard let longitude = Double(cellule?.lon ?? "2.344312") else { return }
        guard let title = cellule?.displayName.cutEndString() else { return }
        guard let subtitle = cellule?.displayName.cutStartString(2) else { return }
        guard let info = cellule?.type else { return }
        
        let coordinateInit = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // test 1
        let regionLatitudinalMeters: CLLocationDistance = 5000
        let regionLongitudinalMeters: CLLocationDistance = 5000
        let coordinRegion = MKCoordinateRegion(center: coordinateInit,
                                               latitudinalMeters: regionLatitudinalMeters,
                                               longitudinalMeters: regionLongitudinalMeters)
        mapView.setRegion(coordinRegion, animated: true)

        // test 2
//        let span = MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3)
//        let region = MKCoordinateRegion(center: coordinateInit, span: span)
//        mapView.setRegion(region, animated: true)
        
        let place = Poi(title: title, subtitle: subtitle, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), info: info)
        
        mapView.showsUserLocation = true
        mapView.delegate = self
//        mapView.isZoomEnabled = true
//        mapView.isScrollEnabled = true
        mapView.addAnnotation(place)
    }
    
//    private func locationManagerFunc() {
//        self.locationManager.requestAlwaysAuthorization()
//        self.locationManager.requestWhenInUseAuthorization()
//
////        if CLLocationManager.locationServicesEnabled() {
////            locationManager.delegate = self
////            locationManager.desiredAccuracy = kCLLocationAccuracyBest
////            locationManager.startUpdatingLocation()
////        }
//        mapView.delegate = self
//        mapView.mapType = .standard
//        mapView.isZoomEnabled = true
//        mapView.isScrollEnabled = true
//
//        if let coor = mapView.userLocation.location?.coordinate {
//            mapView.setCenter(coor, animated: true)
//        }
//    }

//    private func displayMap() {
//        // point central longitude / latitude => 49.051111,2.206869
//        guard let latitude = cellule?.geometry.location.lat else { return }
//        guard let longitude = cellule?.geometry.location.lng else { return }
//        let locationBase = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let regionLatitudinalMeters: CLLocationDistance = 5000
//        let regionLongitudinalMeters: CLLocationDistance = 5000
//        let coordinRegion = MKCoordinateRegion(center: locationBase,
//                                               latitudinalMeters: regionLatitudinalMeters,
//                                               longitudinalMeters: regionLongitudinalMeters)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = locationBase
//        annotation.title = cellule?.name
//        annotation.subtitle = cellule?.formattedAddress
//        mapMKMapView.addAnnotation(annotation)
//        self.mapView.setRegion(coordinRegion, animated: true)
//    }

//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
//        if let locValue: CLLocationCoordinate2D = manager.location?.coordinate {
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = locValue
//            annotation.title = "current location"
//            annotation.subtitle = "current location"
//            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//            let region = MKCoordinateRegion(center: locValue, span: span)
//            mapView.addAnnotation(annotation)
//            mapView.setRegion(region, animated: true)
//        } else {
//            print("locvalue is nil")
//        }

//        if locations.count > 0 {
//            if let myPosition = locations.last {
//                userPosition = myPosition
//            }
//        }
//        mapView.mapType = MKMapType.standard

//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: locValue, span: span)
        
//        mapView.setRegion(region, animated: true)

//        let annotation = MKPointAnnotation()
//        annotation.coordinate = locValue
//        annotation.title = "current location"
//        annotation.subtitle = "current location"
//        mapView.addAnnotation(annotation)

//        centerMap(locValue)
//        mapMKMapView.setCenter(locValue, animated: true)
//        mapView.setRegion(region, animated: true)
//    }

}

extension MapViewController: CLLocationManagerDelegate {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        mapView.camera.heading = newHeading.magneticHeading
        mapView.setCamera(mapView.camera, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            if let myPosition = locations.last {
                userPosition = myPosition
            }
        }
    }
}

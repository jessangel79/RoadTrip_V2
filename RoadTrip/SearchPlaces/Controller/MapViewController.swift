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

import GoogleMobileAds

class MapViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var changeMapTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var locateMeButton: UIButton!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    var cellule: PlacesSearchElement?
    var userPosition: CLLocation?
    let identifierPoi = Constants.IdentifierPoi
    var latitude: Double?
    var longitude: Double?
    var titleName: String?
    var subtitle: String?
    var info: String?
    var phone: String?
    let adMobService = AdMobService()
//    var isViewDidAppearCalled = false
        
    var coordinateInit: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude ?? 48.863581, longitude: longitude ?? 2.344312)
    }

    // MARK: - Actions
    
    @IBAction func changeMapTypeButtonTapped(_ sender: UISegmentedControl) {
        switch changeMapTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = MKMapType.standard
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid

        }
    }
    
    @IBAction func locateMeButtonTapped(_ sender: UIButton) {
        guard let userPositionCoordinate = userPosition?.coordinate else { return }
        setupMap(coordinates: userPositionCoordinate, myLat: 0.05, myLon: 0.05)
    }
    
    /// display the place
    @IBAction func refreshBarButtonItemTapped(_ sender: UIBarButtonItem) {
        setupMap(coordinates: coordinateInit, myLat: 0.05, myLon: 0.05)
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        adMobService.setAdMob(bannerView, self)
        adMobService.adMobCanRequestAdsLoadBannerAd(bannerView, view)
        mapView.register(PoiAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        customUI()
        setupData()
        setupLocationManager()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adMobService.adMobCanRequestAdsLoadBannerAd(bannerView, view)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { [self] _ in
            adMobService.adMobCanRequestAdsLoadBannerAd(bannerView, view)
        }
    }
    
    // MARK: - Methods
    
    private func customUI() {
        customButton(button: locateMeButton, radius: 5, width: 1.0, colorBackground: #colorLiteral(red: 0.7162324786, green: 0.7817066312, blue: 1, alpha: 0.7516320634), colorBorder: #colorLiteral(red: 0.397138536, green: 0.09071742743, blue: 0.3226287365, alpha: 1))
    }
    
    func setupData() {
        latitude = Double(cellule?.lat ?? Constants.LatitudeDefault)
        longitude = Double(cellule?.lon ?? Constants.LongitudeDefault)
        titleName = cellule?.displayName.cutEndString()
        subtitle = cellule?.displayName.cutStartString(2)
        info = cellule?.type.capitalized
        phone = cellule?.extratags?.phone
    }
}

// MARK: - Extension MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    private func setup() {
        let regionLatitudinalMeters: CLLocationDistance = 5000
        let regionLongitudinalMeters: CLLocationDistance = 5000
        let coordinRegion = MKCoordinateRegion(center: coordinateInit,
                                               latitudinalMeters: regionLatitudinalMeters,
                                               longitudinalMeters: regionLongitudinalMeters)
        mapView.setRegion(coordinRegion, animated: true)
        let place = Poi(title: titleName ?? "N/A", subtitle: subtitle ?? "N/A", coordinate: coordinateInit, info: info ?? "N/A", phone: phone ?? "N/A")
        setupMapView(place)
    }
    
    private func setupMapView(_ place: Poi) {
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.isRotateEnabled = true
        mapView.addAnnotation(place)
    }
    
    /// for button "Locate me"
    private func setupMap(coordinates: CLLocationCoordinate2D, myLat: Double, myLon: Double) {
        let span = MKCoordinateSpan(latitudeDelta: myLat, longitudeDelta: myLon)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    /// display title and info of place in an alert user with an info button
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let poi = view.annotation as? Poi else { return }
        let placeName = poi.title ?? ""
        let placeInfo = "Activities : \(poi.info ?? "") - Adresse : \(poi.subtitle ?? "") - Phone : \(poi.phone ?? "")"
        presentAlertMapInfo(placeName, placeInfo)
    }
    
    /// define an overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let capitalAreaRenderer = MKCircleRenderer(circle: overlay as? MKCircle ?? MKCircle())
        capitalAreaRenderer.strokeColor = UIColor.lightGray
        return capitalAreaRenderer
    }
}

// MARK: - Extension CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /// manage the change of location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            if let myPosition = locations.last {
                userPosition = myPosition
            }
        }
    }
    
    /// allow to rotate the map - display of callout
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        mapView.camera.heading = newHeading.magneticHeading
        mapView.setCamera(mapView.camera, animated: true)
    }
    
}

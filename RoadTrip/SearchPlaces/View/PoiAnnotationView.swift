//
//  PoiAnnotationView.swift
//  RoadTrip
//
//  Created by Angelique Babin on 08/09/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import MapKit

class PoiAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = Constants.IdentifierPoi
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            let infoButton = UIButton(type: .detailDisclosure)
            infoButton.tintColor = .systemPurple
            rightCalloutAccessoryView = infoButton
            leftCalloutAccessoryView = setupLeft()
        }
    }
    
    func setupLeft() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.setImage(UIImage(named: "distance"), for: .normal)
        button.addTarget(self, action: #selector(gps), for: .touchUpInside)
        return button
    }
    
    @objc func gps() {
        guard let annotation = annotation as? Poi else { return }
        let placemark = MKPlacemark(coordinate: annotation.coordinate)
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault]
        let map = MKMapItem(placemark: placemark)
        map.name = annotation.title
        map.phoneNumber = annotation.phone
        map.openInMaps(launchOptions: options)
    }
}

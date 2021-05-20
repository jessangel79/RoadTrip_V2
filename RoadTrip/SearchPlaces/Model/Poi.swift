//
//  Poi.swift
//  RoadTrip
//
//  Created by Angelique Babin on 07/09/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation
import MapKit

class Poi: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var info: String?
    var phone: String?
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, info: String, phone: String) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.info = info
        self.phone = phone
    }
}

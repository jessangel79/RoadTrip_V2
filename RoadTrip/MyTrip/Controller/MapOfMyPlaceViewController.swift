//
//  MapOfMyPlaceViewController.swift
//  RoadTrip
//
//  Created by Angelique Babin on 07/09/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

final class MapOfMyPlaceViewController: MapViewController {
    
    // MARK: - Properties
    
    var celluleEntity: PlaceEntity?

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupData() {
        latitude = Double(celluleEntity?.lat ?? "48.863581")
        longitude = Double(celluleEntity?.lon ?? "2.344312")
        titleName = celluleEntity?.name
        subtitle = celluleEntity?.address
        info = celluleEntity?.types
    }
}

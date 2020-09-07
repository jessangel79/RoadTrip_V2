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

class MapOfMyPlaceViewController: MapViewController {
    
    // MARK: - Properties
    
    var celluleEntity: PlaceEntity?

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // TODO
//    override func setupData() {
//        guard let latitude = Double(celluleEntity?.lat ?? "48.863581") else { return }
//        guard let longitude = Double(celluleEntity?.lon ?? "2.344312") else { return }
//        guard let title = celluleEntity?.name else { return }
//        guard let subtitle = cellule?.address else { return }
//        guard let info = cellule?.type else { return }
//    }
}

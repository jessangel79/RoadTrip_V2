//
//  ItemTraveller.swift
//  RoadTrip
//
//  Created by Angelique Babin on 15/12/2021.
//  Copyright © 2021 Angelique Babin. All rights reserved.
//

import Foundation
 
class ItemTraveller {
    var travellerName: String?
    var items: [ItemEntity]?
    
    init(travellerName: String, items: [ItemEntity]) {
        self.travellerName = travellerName
        self.items = items
    }
}

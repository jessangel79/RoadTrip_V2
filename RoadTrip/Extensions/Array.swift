//
//  Array.swift
//  RoadTrip
//
//  Created by Angelique Babin on 26/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    mutating func remove(_ element: Element) {
        _ = firstIndex(of: element).flatMap {
            self.remove(at: $0)
        }
    }
}

//
//  Array.swift
//  RoadTrip
//
//  Created by Angelique Babin on 15/12/2021.
//  Copyright © 2021 Angelique Babin. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    /// remove a duplicate in an array
    var removingDuplicates: [Element] {
        return self.reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}

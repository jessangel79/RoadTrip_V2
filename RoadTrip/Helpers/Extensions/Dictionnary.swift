//
//  Dictionnary.swift
//  RoadTrip
//
//  Created by Angelique Babin on 30/03/2022.
//  Copyright © 2022 Angelique Babin. All rights reserved.
//

import Foundation

extension Dictionary where Value: Comparable { // Equatable
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 >= val }.map { $0.0 }
//        return self.filter { $1 == val }.map { $0.0 }
    }
}

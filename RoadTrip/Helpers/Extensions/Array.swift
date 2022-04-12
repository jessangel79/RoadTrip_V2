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
    
//    func compareArray(array1: [String], array2: [String]) -> Bool {
//        var someHash: [String: Bool] = [:]
//        var commonItemsExist = false
//        array1.forEach { someHash[$0] = true }
//        array2.forEach { item in
//            if someHash[item] ?? false {
//                commonItemsExist = true
//            } else {
//                commonItemsExist = false
//            }
//        }
//        return commonItemsExist
//    }
}

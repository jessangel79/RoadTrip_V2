//
//  Sequence.swift
//  RoadTrip
//
//  Created by Angelique Babin on 18/02/2022.
//  Copyright © 2022 Angelique Babin. All rights reserved.
//

import Foundation

extension Sequence where Element: Hashable {
    var histogram: [Element: Int] {
        return self.reduce(into: [:]) { counts, elem in counts[elem, default: 0] += 1 }
    }
}

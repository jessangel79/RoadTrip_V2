//
//  PriceLevel.swift
//  RoadTrip
//
//  Created by Angelique Babin on 15/06/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation

enum PriceLevel: String {
    case oneE
    case twoE
    case threeE
    case fourE
    case noa
    
    func priceLevel() -> String? {
        switch self {
        case .oneE:
            return "€"
        case .twoE:
            return "€€"
        case .threeE:
            return "€€€"
        case .fourE:
            return "€€€€"
        case .noa:
            return "N/A"
        }
    }
}

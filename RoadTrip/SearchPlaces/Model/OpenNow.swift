//
//  OpenNow.swift
//  RoadTrip
//
//  Created by Angelique Babin on 15/06/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation

// MARK: - Enumeration for the different opening states

enum OpenNow: String {
    case open
    case closed
    case noa
    
    func openNow() -> String? {
        switch self {
        case .open:
            return "Open"
        case .closed:
            return "Closed"
        case .noa:
            return "N/A"
        }
    }
}

//
//  Importance.swift
//  RoadTrip
//
//  Created by Angelique Babin on 02/09/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation

enum Importance: String {
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case noa
    
    func importanceFunc() -> String? {
        switch self {
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        case .four:
            return "4"
        case .five:
            return "5"
        case .six:
            return "6"
        case .seven:
            return "7"
        case .eight:
            return "8"
        case .nine:
            return "9"
        case .noa:
            return "N/A"
        }
    }
}

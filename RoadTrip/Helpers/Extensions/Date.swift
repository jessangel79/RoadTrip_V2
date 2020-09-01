//
//  Date.swift
//  RoadTrip
//
//  Created by Angelique Babin on 12/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation

extension Date {
    
    /// calculate number of days between a start date and an end date
    func timeSinceDateInDays(fromDate: Date) -> String {
        let earliest = self < fromDate ? self  : fromDate
        let latest = earliest == self ? fromDate : self
        let components: DateComponents = Calendar.current.dateComponents([.day], from: earliest, to: latest)
        let day = components.day ?? 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let fromDateSring = dateFormatter.string(from: fromDate)
        if day >= 2 {
            return "\(day) days"
        } else if day >= 1 {
            return "1 day"
        } else {
            return "The \(fromDateSring)"
        }
    }
}

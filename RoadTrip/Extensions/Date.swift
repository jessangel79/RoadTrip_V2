//
//  Date.swift
//  RoadTrip
//
//  Created by Angelique Babin on 12/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation

extension Date {

    /// format type date in type string
//    func toString(format: String = "dd-MM-yyyy") -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.dateFormat = format
//        return formatter.string(from: self)
//    }
    
//    func dateAndTimetoString(format: String = "dd-MM-yyyy HH:mm") -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.dateFormat = format
//        return formatter.string(from: self)
//    }
   
//    func timeIn24HourFormat() -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .none
//        formatter.dateFormat = "HH:mm"
//        return formatter.string(from: self)
//    }
    
//    func startOfMonth() -> Date {
//        var components = Calendar.current.dateComponents([.year, .month], from: self)
//        components.day = 1
//        let firstDateOfMonth: Date = Calendar.current.date(from: components)!
//        return firstDateOfMonth
//    }
    
//    func endOfMonth() -> Date {
//        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
//    }
    
//    func nextDate() -> Date {
//        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: self)
//        return nextDate ?? Date()
//    }
//
//    func previousDate() -> Date {
//        let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: self)
//        return previousDate ?? Date()
//    }
//
//    func addMonths(numberOfMonths: Int) -> Date {
//        let endDate = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self)
//        return endDate ?? Date()
//    }
//
//    func removeMonths(numberOfMonths: Int) -> Date {
//        let endDate = Calendar.current.date(byAdding: .month, value: -numberOfMonths, to: self)
//        return endDate ?? Date()
//    }
//
//    func removeYears(numberOfYears: Int) -> Date {
//        let endDate = Calendar.current.date(byAdding: .year, value: -numberOfYears, to: self)
//        return endDate ?? Date()
//    }
    
//    func getHumanReadableDayString() -> String {
//        let weekdays = [
//            "Sunday",
//            "Monday",
//            "Tuesday",
//            "Wednesday",
//            "Thursday",
//            "Friday",
//            "Saturday"
//        ]
//        
//        let calendar = Calendar.current.component(.weekday, from: self)
//        return weekdays[calendar - 1]
//    }
    
    func timeSinceDateInDays(fromDate: Date) -> String {
        let earliest = self < fromDate ? self  : fromDate
        let latest = earliest == self ? fromDate : self
        let components: DateComponents = Calendar.current.dateComponents([.day], from: earliest, to: latest)
        let day = components.day ?? 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd/MM/yyyy"
//        dateFormatter.dateFormat = "MM/dd/yyyy"
        let fromDateSring = dateFormatter.string(from: fromDate)
        if day >= 2 {
            return "\(day) days"
        } else if day >= 1 {
            return "1 day"
        } else {
            return "The \(fromDateSring)"
//            return "Just the \(fromDateSring)"
        }
    }
}

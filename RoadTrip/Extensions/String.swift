//
//  String.swift
//  RoadTrip
//
//  Created by Angelique Babin on 12/02/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import Foundation

extension String {
    /// Check if a string contains at least one element
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespaces) == String() ? true : false
    }

    /// encode string for url
    var stringUrlAllowed: String {
        let string = self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        return string
    }
    
    /// replace dash by whitespace
    var changeDash: String {
        let dashChanged = self.replacingOccurrences(of: "_", with: " ")
        return dashChanged
    }
    
    /// delete whitespaces
    var deleteWhitespaces: String {
        let whitespacesDeleted = self.replacingOccurrences(of: " ", with: "")
        return whitespacesDeleted
    }
    
    /// delete whitespace to trailing and leading of string
    var trimWhitespaces: String {
        let trimmed = self.trimmingCharacters(in: .whitespaces)
        return trimmed
    }
    
    /// format type string in type date
    func toDate(format: String = "dd/MM/yyyy") -> Date {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.date(from: self) ?? Date()
    }
}

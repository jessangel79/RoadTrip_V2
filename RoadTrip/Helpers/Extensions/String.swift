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
    
    func cutEndString() -> String {
        guard let endOfSentence = self.firstIndex(of: ",") else { return "" }
//        let endOfSentence = self.firstIndex(of: ",")!
        var firstSentence = self[...endOfSentence]
        firstSentence.removeLast()
        return String(firstSentence)
    }
    
    func cutStartString(_ int: Int) -> String {
        guard let endOfSentence = self.firstIndex(of: ",") else { return "" }
        var firstSentence = self[endOfSentence...]
        firstSentence.removeFirst(int)
        return String(firstSentence)
     }
    
    enum Importance: String {
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case noa = "N/A"
    }
    
    func importanceString() -> String? {
        
        switch self {
        case "0.1":
            return Importance.one.rawValue
        case "0.2":
            return Importance.two.rawValue
        case "0.3":
            return Importance.three.rawValue
        case "0.4":
            return Importance.four.rawValue
        case "0.5":
             return Importance.five.rawValue
        case "0.6":
             return Importance.six.rawValue
        case "0.7":
             return Importance.seven.rawValue
        case "0.8":
             return Importance.eight.rawValue
        case "0.9":
             return Importance.nine.rawValue
        default:
            return Importance.noa.rawValue
        }
    }
}

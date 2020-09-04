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
    
    func importanceString() -> String? {
        switch self {
        case "0.1":
            return Importance.one.importanceFunc()
        case "0.2":
            return Importance.two.importanceFunc()
        case "0.3":
            return Importance.three.importanceFunc()
        case "0.4":
            return Importance.four.importanceFunc()
        case "0.5":
             return Importance.five.importanceFunc()
        case "0.6":
             return Importance.six.importanceFunc()
        case "0.7":
             return Importance.seven.importanceFunc()
        case "0.8":
             return Importance.eight.importanceFunc()
        case "0.9":
             return Importance.nine.importanceFunc()
        default:
            return Importance.noa.importanceFunc()
        }
    }
    
//            let length = 20
//            if placeName.count > length {
//                var shortName = Substring(placeName)
//                return String(shortName)
//            }
}

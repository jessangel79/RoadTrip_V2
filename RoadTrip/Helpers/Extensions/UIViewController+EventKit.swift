//
//  UIViewController+EventKit.swift
//  RoadTrip
//
//  Created by Angelique Babin on 06/03/2020.
//  Copyright © 2020 Angelique Babin. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

// MARK: - Extension to manage agenda

extension UIViewController: EKEventEditViewDelegate {
    
    /// Generate an event which will be then added to the calendar
    func generateEvent(title: String, location: String) {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined:
            print("User run this app for the first")
            eventStore.requestAccess(to: .event) { (granted, error) in
                if granted {
                    print("granted \(granted)")
                    DispatchQueue.main.async {
                        self.showEventViewController(eventStore, title: title, location: location)
                    }
                }
            }
        case .authorized:
            print("User has access to calendar")
            DispatchQueue.main.async {
                self.showEventViewController(eventStore, title: title, location: location)
            }
        default:
            presentAlert(typeError: .errorAccess)
        }
    }
    
    /// Set event to save
    private func setEvent(_ event: EKEvent, title: String, location: String) {
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(2 * 60 * 60)
        event.startDate = startDate
        event.endDate = endDate
        event.title = title
        event.location = location
    }
    
    /// Present to user an event which will be then added to the calendar
    private func showEventViewController(_ eventStore: EKEventStore, title: String, location: String) {
        let eventVC = EKEventEditViewController()
        let event = EKEvent(eventStore: eventStore)
        eventVC.event = event
        eventVC.editViewDelegate = self
        eventVC.eventStore = eventStore
        event.calendar = eventVC.eventStore.defaultCalendarForNewEvents
        setEvent(event, title: title, location: location)
        present(eventVC, animated: true)
    }
    
    /// Method to dismiss agenda
    public func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        self.dismiss(animated: true, completion: nil)
        switch action {
        case .canceled:
            print("Event canceled")
        case .saved:
            print("Event saved")
        default:
            print("default")
        }
    }
}

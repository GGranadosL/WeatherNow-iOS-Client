//
//  CalendarService.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 27/08/24.
//

import EventKit
import EventKitUI

class CalendarService {
    let eventStore = EKEventStore()

    // Request full access to the user's calendar
    func requestFullCalendarAccess(completion: @escaping (Bool, Error?) -> Void) {
        eventStore.requestFullAccessToEvents { granted, error in
            completion(granted, error)
        }
    }
    
    // Request write-only access to the user's calendar (if read access is not needed)
    func requestWriteOnlyCalendarAccess(completion: @escaping (Bool, Error?) -> Void) {
        eventStore.requestWriteOnlyAccessToEvents { granted, error in
            completion(granted, error)
        }
    }

    // Add a reminder to the user's calendar
    func addWeatherReminder(title: String, startDate: Date, endDate: Date, completion: @escaping (Result<EKEvent, Error>) -> Void) {
        // Ensure access has already been granted before adding events
        eventStore.requestFullAccessToEvents { [weak self] granted, error in
            guard let self = self else { return }
            guard granted else {
                completion(.failure(error ?? NSError(domain: "CalendarAccessDenied", code: 1, userInfo: nil)))
                return
            }

            let event = EKEvent(eventStore: self.eventStore)
            event.title = title
            event.startDate = startDate
            event.endDate = endDate
            event.calendar = self.eventStore.defaultCalendarForNewEvents

            do {
                try self.eventStore.save(event, span: .thisEvent)
                completion(.success(event))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

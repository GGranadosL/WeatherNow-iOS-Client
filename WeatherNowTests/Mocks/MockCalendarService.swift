//
//  MockCalendarService.swift
//  WeatherNowTests
//
//  Created by Gerardo  Granados Lopez on 02/09/24.
//

import Foundation
import EventKit
@testable import WeatherNow

class MockCalendarService: CalendarService {
    override func requestFullCalendarAccess(completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
    }
    
    override func addWeatherReminder(title: String, startDate: Date, endDate: Date, completion: @escaping (Result<EKEvent, Error>) -> Void) {
        let mockEvent = EKEvent(eventStore: EKEventStore())
        mockEvent.title = title
        completion(.success(mockEvent))
    }
}


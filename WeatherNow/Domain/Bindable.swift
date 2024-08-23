//
//  Bindable.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 23/08/24.
//

import Foundation

class Bindable<T> {
    private var listeners: [(T) -> Void] = []
    
    var value: T {
        didSet {
            notifyListeners()
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: @escaping (T) -> Void) {
        listeners.append(listener)
        listener(value)
    }
    
    private func notifyListeners() {
        listeners.forEach { $0(value) }
    }
}



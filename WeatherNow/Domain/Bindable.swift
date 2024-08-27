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
    
    /// Binds a listener to the Bindable instance.
    /// - Parameter listener: The closure to be called when the value changes.
    func bind(listener: @escaping (T) -> Void) {
        // Evitar agregar listeners duplicados
        if !listeners.contains(where: { $0 as AnyObject === listener as AnyObject }) {
            listeners.append(listener)
            listener(value)
        }
    }
    
    /// Unbinds a listener from the Bindable instance.
    /// - Parameter listener: The closure to be removed from the listeners.
    func unbind(listener: @escaping (T) -> Void) {
        listeners = listeners.filter { $0 as AnyObject !== listener as AnyObject }
    }
    
    /// Notifies all listeners of a value change.
    func notifyListeners() {
        listeners.forEach { $0(value) }
    }
    
    /// Notifies all listeners on the main thread.
    func notifyListenersOnMainThread() {
        DispatchQueue.main.async {
            self.notifyListeners()
        }
    }
}




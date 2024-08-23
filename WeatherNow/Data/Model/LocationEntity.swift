//
//  LocationEntity.swift
//  WeatherNow
//
//  Created by Gerardo  Granados Lopez on 22/08/24.
//

import Foundation

// Representa un modelo de ubicación en el contexto de almacenamiento persistente (por ejemplo, Core Data o almacenamiento local).
struct LocationEntity {
    let id: String
    let cityName: String
    let latitude: String
    let longitude: String
    let registrationDate: String
}




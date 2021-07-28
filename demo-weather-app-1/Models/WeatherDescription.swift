//
//  WeatherDescription.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 26/7/21.
//

import Foundation
struct WeatherDescription: Codable {
    let description: String
    let id: Int
    let main: String
    let icon: String
}

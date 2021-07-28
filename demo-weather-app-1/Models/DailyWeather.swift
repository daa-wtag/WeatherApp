//
//  DailyWeather.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 26/7/21.
//

import Foundation
struct DailyWeather: Codable{
    let dt: Double
    let sunrise: Double
    let sunset: Double
    let moonrise: Double
    let moonset: Double
    let temp: DailyTemperature
    let weather: [WeatherDescription]
    let humidity: Int
    let wind_speed: Double
    let clouds: Int
}

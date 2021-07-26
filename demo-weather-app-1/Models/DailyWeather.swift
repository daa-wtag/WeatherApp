//
//  DailyWeather.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 26/7/21.
//

import Foundation
struct DailyWeather:Codable{
    let dt:Double
    let temp:DailyTemperature
    let weather:[WeatherDescription]
}

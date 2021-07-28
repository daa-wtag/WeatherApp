//
//  WeeklyJsonDataAsStruct.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 14/7/21.
//

import Foundation
struct WeeklyWeatherData: Codable { // // 7 days weather "json data as struct"
    let daily: [DailyWeather]
}


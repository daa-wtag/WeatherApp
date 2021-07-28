//
//  JsonDataAsStruct.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 13/7/21.
//

import Foundation
struct TodaysWeatherData: Codable{ // todays weather "json data as struct"
    let main: MainWeather
    let weather: [WeatherDescription]
    let sys: SunriseSunsetdata
    let name: String
    let clouds: CloudPercentage
    let wind: WindData
}





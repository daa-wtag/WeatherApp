//
//  RealmClassDailyWeather.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 29/7/21.
//

import Foundation
import RealmSwift
class RealmClassDailyWeather: Object{
    @Persisted var dt: Double?
    @Persisted var sunrise: Double?
    @Persisted var sunset: Double?
    @Persisted var moonrise: Double?
    @Persisted var moonset: Double?
    @Persisted var temp: RealmsClassDailyTemperature?
    @Persisted var weather: RealmClassWeatherDescription?
    @Persisted var humidity: Int?
    @Persisted var wind_speed: Double?
    @Persisted var clouds: Int?
    convenience init(dt: Double,sunrise: Double,sunset: Double,moonrise: Double,moonset: Double,temp:RealmsClassDailyTemperature,weather: RealmClassWeatherDescription, humidity: Int, wind_speed: Double, clouds: Int){
        self.init()
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.moonrise = moonrise
        self.moonset = moonset
        self.temp = temp
        self.weather = weather
        self.humidity = humidity
        self.wind_speed = wind_speed
        self.clouds = clouds
    }
}

//
//  RealmClassTodaysWeatherData.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 29/7/21.
//

import Foundation
import RealmSwift
class RealmClassTodaysWeatherData: Object{ // todays weather "json data as struct"
    @Persisted var main: RealmClassMainWeather?
    @Persisted var weather: List<RealmClassWeatherDescription>
    @Persisted var sys: RealmClassSunriseSunsetdata?
    @Persisted var name: String?
    @Persisted var clouds: RealmClassCloudPercentage?
    @Persisted var wind: RealmClassWindData?
    
    static func createObject(with decodedData:TodaysWeatherData) -> RealmClassTodaysWeatherData{
        let task = RealmClassTodaysWeatherData()
        task.main = RealmClassMainWeather(temp: decodedData.main.temp, humidity: decodedData.main.humidity)
        for weatherDescription in decodedData.weather{
            task.weather.append(RealmClassWeatherDescription(id: weatherDescription.id, main: weatherDescription.main, icon: weatherDescription.icon))
        }
        task.sys = RealmClassSunriseSunsetdata(country: decodedData.sys.country)
        task.name = decodedData.name
        task.clouds = RealmClassCloudPercentage(all: decodedData.clouds.all)
        task.wind = RealmClassWindData(speed: decodedData.wind.speed)
        return task
    }
}

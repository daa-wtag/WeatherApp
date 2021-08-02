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
}

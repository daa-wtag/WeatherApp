//
//  RealmClassNextSevenDaysWeatherData.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 29/7/21.
//

import Foundation
import RealmSwift
class RealmClassNextSevenDaysWeatherData: Object{
   @Persisted var daily: List<RealmClassDailyWeather>
}

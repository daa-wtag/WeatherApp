//
//  RealmClassMainWeather.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 29/7/21.
//

import Foundation
import RealmSwift
class RealmClassMainWeather: Object{
   @Persisted var temp: Double?
   @Persisted var humidity: Int?
    
    convenience init(temp: Double,humidity: Int) {
        self.init()
        self.temp = temp
        self.humidity = humidity
    }
}

//
//  RealmsClassDailyTemperature.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 29/7/21.
//

import Foundation
import RealmSwift
class RealmsClassDailyTemperature: Object{
    @Persisted var max: Double?
    @Persisted var min: Double?
    convenience init(max: Double, min: Double){
        self.init()
        self.max = max
        self.min = min
    }
}

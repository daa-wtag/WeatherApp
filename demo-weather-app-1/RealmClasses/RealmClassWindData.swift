//
//  RealmClassWindData.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 29/7/21.
//

import Foundation
import RealmSwift
class RealmClassWindData: Object {
    @Persisted var speed: Double?
    convenience init(speed: Double){
        self.init()
        self.speed = speed
    }
}

//
//  RealmClassSunriseSunsetdata.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 29/7/21.
//

import Foundation
import RealmSwift
class RealmClassSunriseSunsetdata: Object {
    @Persisted var country: String?
    convenience init(country: String){
        self.init()
        self.country = country
    }
}

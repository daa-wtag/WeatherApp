//
//  RealmClassWeatherDescription.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 29/7/21.
//

import Foundation
import RealmSwift
class RealmClassWeatherDescription: Object{
    @Persisted var id: Int?
    @Persisted var main: String?
    @Persisted var icon: String?
    
    convenience init(id: Int, main: String, icon: String) {
        self.init()
        self.id = id
        self.main = main
        self.icon = icon
    }
}

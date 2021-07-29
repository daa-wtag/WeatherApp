//
//  RealmClassCloudPercentage.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 29/7/21.
//

import Foundation
import RealmSwift
class RealmClassCloudPercentage: Object{
   @Persisted var all: Int?
    convenience init(all: Int){
        self.init()
        self.all = all
    }
}

//
//  WeeklyJsonDataAsStruct.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 14/7/21.
//

import Foundation
struct WeeklyJsonDataAsStruct:Codable {
    let daily:[Daily]
    struct Daily:Codable{
        let dt:Double
        let temp:Temp
        struct Temp:Codable{
            let max:Double
        }
    }
}

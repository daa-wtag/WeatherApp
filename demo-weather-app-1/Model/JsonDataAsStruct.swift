//
//  JsonDataAsStruct.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 13/7/21.
//

import Foundation
struct JsonDataAsStruct:Codable{
    let main:Main
}
struct Main:Codable{
    let temp:Double
}

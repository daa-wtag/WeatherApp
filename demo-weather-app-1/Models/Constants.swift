//
//  Constants.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 26/7/21.
//

import Foundation
struct Constants{
    
    static func weatherIcon(temp:Double) -> String {
        let anotherTemp = ceil(temp)
        switch anotherTemp {
        case ...0:
            return "snow"
        case 1...20:
            return "thermometer.snowflake"
        case 21...23:
            return "cloud.bolt.rain"
        case 24...26:
            return "cloud.rain"
        case 27...30:
            return "sun.min"
        case 31...40:
            return "sun.max"
        default:
            return "sun.max.fill"
        }
    }
    
    //MARK:- Color names
    static let appBackGroundColor = "newBackgroundColor"
    
    //MARK:- For Segue
    static let weeklySegue = "weeklySegue"
    static let weeklyVcStoryBoardIdentifier = "weeklyVC"
    static let detailsOfDailyWeatherIdentifier = "detailsOfDailyWeather"
    
    //MARK:- For weather cell
    static let weatherCellIdentifier = "weatherCell"
    
    //MARK:- API
    static let API_KEY = "daf82517e9e888a45db619caeab87202"
    static let openWeatherApiBaseUrl = "https://api.openweathermap.org/data/2.5"
    static let iconDownloadingBaseUrl = "https://openweathermap.org/img/wn/"
}

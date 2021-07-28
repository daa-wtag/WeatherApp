//
//  ApiCallingStruct.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 13/7/21.
//

import Foundation
import Alamofire
import CoreLocation

protocol ApiCallingStructDelegate {
    func updateUI(_ apiCallingStruct: ApiCallingStruct, todaysWeatherData: TodaysWeatherData)
}

protocol ApiCallingStructDelegateWeekly{
    func passWeeklyJsonDataAsStruct(weeklyWeatherData: WeeklyWeatherData)
}


struct ApiCallingStruct {
    
    private let currentWeatherPath = "\(Constants.openWeatherApiBaseUrl)/weather?units=metric&appid=\(Constants.API_KEY)"
    private let weeklyWeatherPath = "\(Constants.openWeatherApiBaseUrl)/onecall?units=metric&exclude=minutely,hourly,current&appid=\(Constants.API_KEY)"
    
    var currentWeatherDelegate: ApiCallingStructDelegate?
    var weeklyWeatherDelegate: ApiCallingStructDelegateWeekly?
    
    
    func callApi(latitude: CLLocationDegrees, longitude: CLLocationDegrees, isWeeklyForcast: Bool = false){
        let urlString:String
        let latitudeLongitude:String = "&lat=\(latitude)&lon=\(longitude)"
        if isWeeklyForcast{
            urlString = weeklyWeatherPath + latitudeLongitude
        }else{
            urlString = currentWeatherPath + latitudeLongitude
        }
   
        let requestObject = AF.request(urlString)
        
        if isWeeklyForcast{
            requestObject.responseDecodable(of:WeeklyWeatherData.self){ response in
                switch response.result{
                case .success(let decodedData):
                    self.weeklyWeatherDelegate?.passWeeklyJsonDataAsStruct(weeklyWeatherData: decodedData)
                case .failure(let error):
                    print("we got an error \(error)")
                }
            }
        }else{
            requestObject.responseDecodable(of:TodaysWeatherData.self){ response in
                switch response.result{
                case .success(let decodedData):
                    self.currentWeatherDelegate?.updateUI(self, todaysWeatherData: decodedData)
                case .failure(let error):
                    print("we got an error \(error)")
                }
            }
        }
        
    }
}

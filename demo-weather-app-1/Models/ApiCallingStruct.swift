//
//  ApiCallingStruct.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 13/7/21.
//

import Foundation
import CoreLocation

protocol ApiCallingStructDelegate {
    func updateUI(_ apiCallingStruct:ApiCallingStruct,todaysWeatherData:TodaysWeatherData)
}

protocol ApiCallingStructDelegateWeekly{
    func passWeeklyJsonDataAsStruct(weeklyWeatherData:WeeklyWeatherData)
}


struct ApiCallingStruct {
    
    private let currentWeatherPath = "\(Constants.openWeatherApiBaseUrl)/weather?units=metric&appid=\(Constants.API_KEY)"
    private let weeklyWeatherPath = "\(Constants.openWeatherApiBaseUrl)/onecall?units=metric&exclude=minutely,hourly,current&appid=\(Constants.API_KEY)"
    
    var currentWeatherDelegate:ApiCallingStructDelegate?
    var weeklyWeatherDelegate:ApiCallingStructDelegateWeekly?
    
    
    func callApi(latitude:CLLocationDegrees,longitude:CLLocationDegrees,isWeeklyForcast:Bool = false){
        let urlString:String
        let latitudeLongitude:String = "&lat=\(latitude)&lon=\(longitude)"
        if isWeeklyForcast{
            urlString = weeklyWeatherPath + latitudeLongitude
        }else{
            urlString = currentWeatherPath + latitudeLongitude
        }
        
       
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print("we got an error while fetching data from internet. error is \n \(error!)")
                    return
                }
                
                if let data = data{
                    do{
                        if isWeeklyForcast{
                            let decodedData = try JSONDecoder().decode(WeeklyWeatherData.self, from: data)
                            self.weeklyWeatherDelegate?.passWeeklyJsonDataAsStruct(weeklyWeatherData: decodedData)
                        }else{
                            let decodedData = try JSONDecoder().decode(TodaysWeatherData.self, from: data)
                            self.currentWeatherDelegate?.updateUI(self, todaysWeatherData: decodedData)
                        }
                    }catch{
                        print("we got error while decoding Json to struct \(error)")
                    }
                }
                
            }
            task.resume()
        }else{
            print("Faild to create URL object")
        }
        
    }
}

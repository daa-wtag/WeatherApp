//
//  ApiCallingStruct.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 13/7/21.
//

import Foundation
import CoreLocation

protocol ApiCallingStructDelegate {
    func updateUI(_ apiCallingStruct:ApiCallingStruct,jsonDataAsStruct:JsonDataAsStruct)
    func updateUI(_ apiCallingStruct:ApiCallingStruct,weeklyJsonDataAsStruct:WeeklyJsonDataAsStruct)
}

extension ApiCallingStructDelegate{
    func updateUI(_ apiCallingStruct:ApiCallingStruct,jsonDataAsStruct:JsonDataAsStruct){
        
    }
    
    func updateUI(_ apiCallingStruct:ApiCallingStruct,weeklyJsonDataAsStruct:WeeklyJsonDataAsStruct){
        
    }
}

struct ApiCallingStruct {
    
    private let getFixUrl1 = "https://api.openweathermap.org/data/2.5/weather?appid=daf82517e9e888a45db619caeab87202&units=metric"
    private let getFixUrl2 = "https://api.openweathermap.org/data/2.5/onecall?appid=daf82517e9e888a45db619caeab87202&units=metric&exclude=minutely,hourly,current"
    
    var delegate:ApiCallingStructDelegate?
    
    func callApi(latitude:CLLocationDegrees,longitude:CLLocationDegrees,isWeeklyForcast:Bool = false){
        print(#function)
        let urlString:String
        let commonUrl:String = "&lat=\(latitude)&lon=\(longitude)"
        if isWeeklyForcast{
            urlString = getFixUrl2 + commonUrl
        }else{
            urlString = getFixUrl1 + commonUrl
        }
        print(urlString)
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
                            let decodedData = try JSONDecoder().decode(WeeklyJsonDataAsStruct.self, from: data)
                            self.delegate?.updateUI(self, weeklyJsonDataAsStruct: decodedData)
                        }else{
                            let decodedData = try JSONDecoder().decode(JsonDataAsStruct.self, from: data)
                            self.delegate?.updateUI(self, jsonDataAsStruct: decodedData)
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

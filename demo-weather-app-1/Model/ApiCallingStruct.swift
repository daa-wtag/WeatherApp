//
//  ApiCallingStruct.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 13/7/21.
//

import Foundation
import CoreLocation
struct ApiCallingStruct {
    
    var getFixUrl:String{
        return "https://api.openweathermap.org/data/2.5/weather?appid=daf82517e9e888a45db619caeab87202"
    }
    
    func callApi(latitude:CLLocationDegrees,longitude:CLLocationDegrees){
        print(#function)
        var urlString = "\(getFixUrl)&lat=\(latitude)&lon=\(longitude)&units=metric"
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
                     let decodedData = try JSONDecoder().decode(JsonDataAsStruct.self, from: data)
                        print("temp is \(decodedData.main.temp)")
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

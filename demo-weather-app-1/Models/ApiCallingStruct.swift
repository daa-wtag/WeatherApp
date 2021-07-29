//
//  ApiCallingStruct.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 13/7/21.
//

import Foundation
import Alamofire
import CoreLocation
import RealmSwift

protocol ApiCallingStructDelegate {
    func updateUI(_ apiCallingStruct: ApiCallingStruct, weatherData: Codable)
}

struct ApiCallingStruct {
    let localRealm = try! Realm()
    private let currentWeatherPath = "\(Constants.openWeatherApiBaseUrl)/weather?units=metric&appid=\(Constants.API_KEY)"
    private let weeklyWeatherPath = "\(Constants.openWeatherApiBaseUrl)/onecall?units=metric&exclude=minutely,hourly,current&appid=\(Constants.API_KEY)"
    
    var weatherDelegate: ApiCallingStructDelegate?
    
    func callApi(latitude: CLLocationDegrees, longitude: CLLocationDegrees, isWeeklyForcast: Bool = false){
        let urlString: String
        let latitudeLongitude: String = "&lat=\(latitude)&lon=\(longitude)"
        if isWeeklyForcast{
            urlString = weeklyWeatherPath + latitudeLongitude
        }else{
            urlString = currentWeatherPath + latitudeLongitude
        }
        
        if Connectivity.isConnectedToInternet {
            AF.request(urlString).response{ response in
                switch response.result{
                case .success( _):
                    if isWeeklyForcast{
                        do{
                            let decodedData = try JSONDecoder().decode(NextSevenDaysWeatherData.self, from: response.data!)
                            self.weatherDelegate?.updateUI(self, weatherData: decodedData)
                        }catch{
                            print("got error: \(error)")
                        }
                        
                    }else{
                        do{
                            let decodedData = try JSONDecoder().decode(TodaysWeatherData.self, from: response.data!)
                            print(localRealm.configuration.fileURL!)
                            createDataInRealm(todaysDecodedData: decodedData)
                            self.weatherDelegate?.updateUI(self, weatherData: decodedData)
                        }catch{
                            print("got error: \(error)")
                        }
                    }
                case .failure(let error):
                    print("we got an error \(error)")
                }
            }
        }else{
            if isWeeklyForcast{
                
            }else{
                if let lastTask = localRealm.objects(RealmClassTodaysWeatherData.self).last,
                   let todaysWeatherData = createTodaysWeatherDataObject(with: lastTask) {
                    self.weatherDelegate?.updateUI(self, weatherData: todaysWeatherData)
                    print(lastTask)
                }
            }
            print("offline")
        }
        
    }
    
    func createDataInRealm(todaysDecodedData:TodaysWeatherData){
        let task = RealmClassTodaysWeatherData.createObject(with: todaysDecodedData)
        try! localRealm.write {
            localRealm.add(task)
        }
    }
    
    func createTodaysWeatherDataObject(with lastTask: RealmClassTodaysWeatherData)-> TodaysWeatherData?{
        if let lastTaskMainTemp = lastTask.main?.temp ,
           let lastTaskMainHumidity = lastTask.main?.humidity,
           let lastTaskWeatherLastId = lastTask.weather.last?.id,
           let lastTaskWeatherLastMain = lastTask.weather.last?.main,
           let lastTaskWeatherLastIcon = lastTask.weather.last?.icon,
           let lastTaskSysCountry = lastTask.sys?.country,
           let lastTaskName = lastTask.name,
           let lastTaskCloudsAll = lastTask.clouds?.all,
           let lastTaskWindSpeed = lastTask.wind?.speed{
            let todaysWeatherData = TodaysWeatherData(main: MainWeather(temp: lastTaskMainTemp, humidity: lastTaskMainHumidity),
                                                      weather: [WeatherDescription(id: lastTaskWeatherLastId,
                                                                                   main:lastTaskWeatherLastMain,
                                                                                   icon: lastTaskWeatherLastIcon) ],
                                                      sys: SunriseSunsetdata(country: lastTaskSysCountry),
                                                      name: lastTaskName,
                                                      clouds: CloudPercentage(all: lastTaskCloudsAll),
                                                      wind: WindData(speed: lastTaskWindSpeed)
            )
            
            return todaysWeatherData
        }else{
            return nil
        }
    }
}

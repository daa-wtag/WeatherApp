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
                            let nextSevenDaysWeatherData = try JSONDecoder().decode(NextSevenDaysWeatherData.self, from: response.data!)
                            writeDataInRealm(nextSevenDaysWeatherData: nextSevenDaysWeatherData)
                            self.weatherDelegate?.updateUI(self, weatherData: nextSevenDaysWeatherData)
                        }catch{
                            print("got error: \(error)")
                        }
                        
                    }else{
                        do{
                            let todaysWeatherData = try JSONDecoder().decode(TodaysWeatherData.self, from: response.data!)
                            //print(localRealm.configuration.fileURL!)
                            writeDataInRealm(todaysWeatherData: todaysWeatherData)
                            self.weatherDelegate?.updateUI(self, weatherData: todaysWeatherData)
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
                if let realmClassNextSevenDaysWeatherData = localRealm.objects(RealmClassNextSevenDaysWeatherData.self).last,
                   let nextSevenDaysWeatherData = createNextSevenDaysWeatherData(realmClassNextSevenDaysWeatherData: realmClassNextSevenDaysWeatherData){
                    self.weatherDelegate?.updateUI(self, weatherData: nextSevenDaysWeatherData)
                    //print(realmClassNextSevenDaysWeatherData)
                }
            }else{
                if let realmClassTodaysWeatherData = localRealm.objects(RealmClassTodaysWeatherData.self).last,
                   let todaysWeatherData = createTodaysWeatherData(with: realmClassTodaysWeatherData) {
                    self.weatherDelegate?.updateUI(self, weatherData: todaysWeatherData)
                    //print(realmClassTodaysWeatherData)
                }
            }
        }
        
    }
    //MARK:- TodaysWeatherData back and forth RealmClassTodaysWeatherData
    func writeDataInRealm(todaysWeatherData:TodaysWeatherData){
        let task = createRealmClassTodaysWeatherData(with: todaysWeatherData)
        try! localRealm.write {
            localRealm.add(task)
        }
    }
    
    func createTodaysWeatherData(with realmClassTodaysWeatherData: RealmClassTodaysWeatherData)-> TodaysWeatherData?{
        if let temp = realmClassTodaysWeatherData.main?.temp ,
           let humidity = realmClassTodaysWeatherData.main?.humidity,
           let id = realmClassTodaysWeatherData.weather.last?.id,
           let weatherMain = realmClassTodaysWeatherData.weather.last?.main,
           let icon = realmClassTodaysWeatherData.weather.last?.icon,
           let country = realmClassTodaysWeatherData.sys?.country,
           let name = realmClassTodaysWeatherData.name,
           let cloudPercentage = realmClassTodaysWeatherData.clouds?.all,
           let windSpeed = realmClassTodaysWeatherData.wind?.speed{
            let todaysWeatherData = TodaysWeatherData(main: MainWeather(temp: temp, humidity: humidity),
                                                      weather: [WeatherDescription(id: id,
                                                                                   main:weatherMain,
                                                                                   icon: icon) ],
                                                      sys: SunriseSunsetdata(country: country),
                                                      name: name,
                                                      clouds: CloudPercentage(all: cloudPercentage),
                                                      wind: WindData(speed: windSpeed)
            )
            
            return todaysWeatherData
        }else{
            return nil
        }
    }
    
    func createRealmClassTodaysWeatherData(with todaysWeatherData:TodaysWeatherData) -> RealmClassTodaysWeatherData{
        let task = RealmClassTodaysWeatherData()
        task.main = RealmClassMainWeather(temp: todaysWeatherData.main.temp, humidity: todaysWeatherData.main.humidity)
        for weatherDescription in todaysWeatherData.weather{
            task.weather.append(RealmClassWeatherDescription(id: weatherDescription.id, main: weatherDescription.main, icon: weatherDescription.icon))
        }
        task.sys = RealmClassSunriseSunsetdata(country: todaysWeatherData.sys.country)
        task.name = todaysWeatherData.name
        task.clouds = RealmClassCloudPercentage(all: todaysWeatherData.clouds.all)
        task.wind = RealmClassWindData(speed: todaysWeatherData.wind.speed)
        return task
    }
    
    //MARK:- NextSevenDaysWeatherData back and forth RealmClassNextSevenDaysWeatherData
    func writeDataInRealm(nextSevenDaysWeatherData:NextSevenDaysWeatherData){
        if let realmClassNextSevenDaysWeatherData = createRealmClassNextSevenDaysWeatherData(nextSevenDaysWeatherData: nextSevenDaysWeatherData){
            try! localRealm.write{
                localRealm.add(realmClassNextSevenDaysWeatherData)
            }
        }
    }
    
    
    func createRealmClassNextSevenDaysWeatherData(nextSevenDaysWeatherData: NextSevenDaysWeatherData)->RealmClassNextSevenDaysWeatherData?{
        let realmClassNextSevenDaysWeatherData = RealmClassNextSevenDaysWeatherData()
        
        for dailyWeather in nextSevenDaysWeatherData.daily{
            guard let lastWeather = dailyWeather.weather.last else{
                return nil
            }
            let realmClassWeatherDescription = RealmClassWeatherDescription(id: lastWeather.id, main: lastWeather.main, icon: lastWeather.icon)
            let realmsClassDailyTemperature = RealmsClassDailyTemperature(max: dailyWeather.temp.max, min: dailyWeather.temp.min)
            let realmClassDailyWeather = RealmClassDailyWeather(dt: dailyWeather.dt, sunrise: dailyWeather.sunrise, sunset: dailyWeather.sunset, moonrise: dailyWeather.moonrise, moonset: dailyWeather.moonset, temp: realmsClassDailyTemperature, weather: realmClassWeatherDescription, humidity: dailyWeather.humidity, wind_speed: dailyWeather.wind_speed, clouds: dailyWeather.clouds)
            realmClassNextSevenDaysWeatherData.daily.append(realmClassDailyWeather)
        }
        return realmClassNextSevenDaysWeatherData
    }
    
    func createNextSevenDaysWeatherData(realmClassNextSevenDaysWeatherData:RealmClassNextSevenDaysWeatherData) -> NextSevenDaysWeatherData?{
        var daily = [DailyWeather]()
        for realmClassDailyWeather in realmClassNextSevenDaysWeatherData.daily{
            if let dt = realmClassDailyWeather.dt,
               let sunrise = realmClassDailyWeather.sunrise,
               let sunset = realmClassDailyWeather.sunset,
               let moonrise = realmClassDailyWeather.moonrise,
               let moonset = realmClassDailyWeather.moonset,
               let tempMax = realmClassDailyWeather.temp?.max,
               let tempMin = realmClassDailyWeather.temp?.min,
               let id = realmClassDailyWeather.weather?.id ,
               let main = realmClassDailyWeather.weather?.main,
               let icon = realmClassDailyWeather.weather?.icon,
               let humidity = realmClassDailyWeather.humidity,
               let wind_speed = realmClassDailyWeather.wind_speed,
               let clouds = realmClassDailyWeather.clouds{
                let temp = DailyTemperature(max: tempMax, min: tempMin)
                let weatherDescription = WeatherDescription(id: id, main: main, icon: icon)
                let dailyWeather = DailyWeather(dt: dt, sunrise: sunrise, sunset: sunset, moonrise: moonrise, moonset: moonset, temp: temp, weather: [weatherDescription], humidity: humidity, wind_speed: wind_speed, clouds: clouds)
                daily.append(dailyWeather)
            }
        }
        
        let nextSevenDaysWeatherData = NextSevenDaysWeatherData(daily: daily)
        return nextSevenDaysWeatherData
    }
}

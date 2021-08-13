//
//  ViewController.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 13/7/21.
//

import UIKit
import CoreLocation
class TodaysWeatherViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!

    
    var locationManager = CLLocationManager()
    var apiCallingObj = ApiCallingStruct()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization() // accessing privacy
        locationManager.delegate = self
        locationManager.requestLocation()
        apiCallingObj.delegate = self
        print("a")
    }
    
    @IBAction func weeklyButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "weeklySeg2", sender: self)
    }
}

//MARK:- CLLocationManagerDelegate
extension TodaysWeatherViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        if let location = locations.last{
            manager.stopUpdatingLocation()
            print(location)
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat)
            print(lon)
            apiCallingObj.callApi(latitude:lat,longitude:lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
        
    }
}

//MARK:- ApiCallingStructDelegate
extension TodaysWeatherViewController:ApiCallingStructDelegate{
    func updateUI(_ apiCallingStruct: ApiCallingStruct,jsonDataAsStruct:TodaysWeather) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = String(format: "%.1f", jsonDataAsStruct.main.temp)
            self.cityLabel.text = jsonDataAsStruct.name
        
            if let lastWeather = jsonDataAsStruct.weather.last{
                self.weatherImageView.downloaded(from: "https://openweathermap.org/img/wn/\(lastWeather.icon)@2x.png")
            }
        }
        
    }
}

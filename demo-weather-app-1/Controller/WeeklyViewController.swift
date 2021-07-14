//
//  WeeklyViewController.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 14/7/21.
//

import UIKit
import CoreLocation

class WeeklyViewController: UIViewController {
  
    @IBOutlet var weeklyWeatherLabels: [UILabel]!
    var locationManager = CLLocationManager()
    var apiCallingStruct = ApiCallingStruct()
    var didFindLocation:Bool?
    override func viewDidLoad() {
        print("\(#function) in weekly viewCOntroller")
        super.viewDidLoad()
        locationManager.delegate = self
        didFindLocation = false
        locationManager.requestLocation()
    }
}

func debug(file: String = #file, line: Int = #line, function: String = #function) -> String {
    return "\(file):\(line) : \(function)"
}

extension WeeklyViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(#function) in weekly viewCOntroller")
        manager.stopUpdatingLocation()
        if didFindLocation == false{
            didFindLocation = true
            if let location = locations.last{
                print(location)
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                apiCallingStruct.callApi(latitude: lat, longitude: lon, isWeeklyForcast: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(#function) in weekly viewCOntroller")
        print("We got an error while trying to get Weekly forecast")
    }
}

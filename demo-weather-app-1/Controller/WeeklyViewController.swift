//
//  WeeklyViewController.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 14/7/21.
//

import UIKit
import CoreLocation

class WeeklyViewController: UIViewController {
  
    @IBOutlet var dateLabels: [UILabel]!
    @IBOutlet var tempLabels: [UILabel]!
    
    var locationManager = CLLocationManager()
    var apiCallingStruct = ApiCallingStruct()
    var didFindLocation:Bool?
    
    
    override func viewDidLoad() {
        print("\(#function) in weekly viewCOntroller")
        super.viewDidLoad()
        locationManager.delegate = self
        apiCallingStruct.delegate = self
        didFindLocation = false
        locationManager.requestLocation()
    }
}

//MARK:- CLLocationManagerDelegate
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

//MARK:- Necessary functions
extension WeeklyViewController{
    func getDate(from dt:Double) -> String {
        let date = NSDate(timeIntervalSince1970: dt) // 1626328800
        //Date formatting
        let dayTimePeriodFormatter = DateFormatter()
        //dayTimePeriodFormatter.dateFormat = "dd/M/YYYY" // 15/7/2021
        dayTimePeriodFormatter.dateFormat = "dd MMM" // 15 Jul
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
}

//MARK:- ApiCallingStructDelegate
extension WeeklyViewController:ApiCallingStructDelegate{
    func updateUI(_ apiCallingStruct:ApiCallingStruct,weeklyJsonDataAsStruct:WeeklyJsonDataAsStruct){
        for i in weeklyJsonDataAsStruct.daily.indices{
            if i == 0{
                continue
            }
        
            DispatchQueue.main.async {
                if i == 1{
                    self.dateLabels[i-1].text = "Tomorrow"
                }else{
                    self.dateLabels[i-1].text = self.getDate(from: weeklyJsonDataAsStruct.daily[i].dt)
                    self.dateLabels[i-1].font.withSize(20)
                }
                
                self.tempLabels[i-1].text = String(format:"%.1f",weeklyJsonDataAsStruct.daily[i].temp.max)
            }
        }
    }
}

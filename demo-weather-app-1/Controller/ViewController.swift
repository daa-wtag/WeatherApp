//
//  ViewController.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 13/7/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    @IBAction func weeklyButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "weeklySeg", sender: self)
    }
    
    var locationManager = CLLocationManager()
    var apiCallingObj = ApiCallingStruct()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization() // accessing privacy
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestLocation()
            apiCallingObj.delegate = self
        }
    }

}

//MARK:- CLLocationManagerDelegate
extension ViewController:CLLocationManagerDelegate{
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
extension ViewController:ApiCallingStructDelegate{
    func updateUI(_ apiCallingStruct: ApiCallingStruct, temp: Double, cityName: String) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = String(format: "%.1f", temp)
            self.cityLabel.text = cityName
        }
    }
}

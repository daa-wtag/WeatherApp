//
//  ViewController.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad  Daihan on  13/7/21.
//

import UIKit
import CoreLocation
class TodaysWeatherViewController: UIViewController {
    
    @IBOutlet weak var cloudPercentageImageView: UIImageView!
    @IBOutlet weak var cloudPercentageLabel: UILabel!
    @IBOutlet weak var windSpeedImageView: UIImageView!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityImageView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    var locationManager = CLLocationManager()
    var apiCallingStruct = ApiCallingStruct()
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization() // accessing privacy
        locationManager.delegate = self
        locationManager.requestLocation()
        apiCallingStruct.weatherDelegate = self
    }
    
    @IBAction func SevenDayForecastButtonPressed(_ sender: UIButton) {
        let nextSevenDaysWeatherVC = storyboard?.instantiateViewController(withIdentifier:Constants.weeklyVcStoryBoardIdentifier) as! NextSevenDaysWeatherViewController
        nextSevenDaysWeatherVC.latitude = self.latitude // passing data to weekly vc
        nextSevenDaysWeatherVC.longitude = self.longitude // passing data to weekly vc
        navigationController?.pushViewController(nextSevenDaysWeatherVC, animated: true)
    }
    
    @IBAction func searchWeatherByCityButtonPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: Constants.searchWeatherByCityIdentifier) as! SearchWeatherByCityViewController
        vc.searchByCityDelegate = self
        navigationController?.pushViewController(vc, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    deinit {
        print("TodaysWeatherViewController is deallocated")
    }
}

//MARK:- CLLocationManagerDelegate
extension TodaysWeatherViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            manager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            apiCallingStruct.callApi(latitude:lat,longitude:lon)
            self.latitude = lat
            self.longitude = lon
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

//MARK:- ApiCallingStructDelegate
extension TodaysWeatherViewController: ApiCallingStructDelegate{
    func updateUI(_ apiCallingStruct: ApiCallingStruct,weatherData:Codable) {
        DispatchQueue.main.async {
            if let todaysWeatherData = weatherData as? TodaysWeatherData{
                print("Updated UI in \(#file):\(#line)")
                self.temperatureLabel.text = String(format: "%.1f", todaysWeatherData.main.temp)
                self.cityLabel.text = todaysWeatherData.name + "," + todaysWeatherData.sys.country
                self.weatherImageView.image = UIImage(systemName: Constants.weatherIcon(temp: todaysWeatherData.main.temp))
                self.weatherDescriptionLabel.text = todaysWeatherData.weather.last?.main
                
                self.cloudPercentageImageView.image = UIImage(systemName: "cloud")
                self.cloudPercentageLabel.text = String(todaysWeatherData.clouds.all) + "%"
                self.windSpeedImageView.image = UIImage(systemName: "wind")
                self.windSpeedLabel.text = String(todaysWeatherData.wind.speed) + "m/s"
                self.humidityImageView.image = UIImage(named: "humidity")
                self.humidityLabel.text = String(todaysWeatherData.main.humidity)+"%"
            }
            
        }
        
    }
}


//MARK:- Passing data to a back view controller
extension TodaysWeatherViewController: SearchWeatherByCityViewControllerDelegate{
    func setLatitudeLongitudeFromSearchWeatherByCityViewController(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        print(#function)
        self.latitude = latitude
        self.longitude = longitude
        if let lat = self.latitude , let lon = self.longitude{
//            print("dhukse \(lat)  \(lon)")
            apiCallingStruct.callApi(latitude: lat, longitude: lon)
        }
    }
}

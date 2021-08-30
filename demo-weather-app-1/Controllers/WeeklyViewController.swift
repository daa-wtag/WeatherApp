//
//  WeeklyViewController.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 14/7/21.
//

import UIKit
import CoreLocation

class WeeklyWeatherViewController: UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
    var weeklyJsonDataAsStruct:WeeklyWeather?
    var locationManager = CLLocationManager()
    var apiCallingStruct = ApiCallingStruct()
    var didFindLocation:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        didFindLocation = false
        locationManager.requestLocation()
        tableView.dataSource = self
        apiCallingStruct.anotherDelegate = self
    }
}

//MARK:- CLLocationManagerDelegat e
extension WeeklyWeatherViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if didFindLocation == false{
            didFindLocation = true
            if let location = locations.last{
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                apiCallingStruct.callApi(latitude: lat, longitude: lon, isWeeklyForcast: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}


//MARK:- ApiCallingStructDelegate
extension WeeklyWeatherViewController:ApiCallingStructDelegateWeekly{
    func passWeeklyJsonDataAsStruct(weeklyData: WeeklyWeather) {
        self.weeklyJsonDataAsStruct = weeklyData
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK:- TableViewDataSource
extension WeeklyWeatherViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = ( weeklyJsonDataAsStruct?.daily.count ?? 1 ) - 1
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.weatherCellIdentifier,for: indexPath) as! WeatherCell
        
        if let dailyWeather = weeklyJsonDataAsStruct?.daily[indexPath.row + 1]{
            cell.updateCell(dailyWeather:dailyWeather , dayOfTheWeek: indexPath.row + 1)
        }
        cell.backgroundColor = UIColor(named: Constants.appBackGroundColor)
        return cell
    }
}

//
//  WeeklyViewController.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 14/7/21.
//

import UIKit
import CoreLocation

class WeeklyViewController: UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
    
    var weeklyJsonDataAsStruct:WeeklyJsonDataAsStruct?
    var locationManager = CLLocationManager()
    var apiCallingStruct = ApiCallingStruct()
    var didFindLocation:Bool?
    
    
    override func viewDidLoad() {
        print("\(#function) in weekly viewCOntroller")
        super.viewDidLoad()
        locationManager.delegate = self
        didFindLocation = false
        locationManager.requestLocation()
        tableView.dataSource = self
        apiCallingStruct.anotherDelegate = self
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


//MARK:- ApiCallingStructDelegate
extension WeeklyViewController:ApiCallingStructDelegateWeekly{
    func passWeeklyJsonDataAsStruct(weeklyData: WeeklyJsonDataAsStruct) {
        self.weeklyJsonDataAsStruct = weeklyData
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK:- TableViewDataSource
extension WeeklyViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = ( weeklyJsonDataAsStruct?.daily.count ?? 1 ) - 1
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherViewCell",for: indexPath) as! WeatherViewCell
        
        if let dailyWeather = weeklyJsonDataAsStruct?.daily[indexPath.row + 1]{
            cell.updateCell(dailyWeather:dailyWeather , dayOfTheWeek: indexPath.row + 1)
        }
        
        return cell
    }
}

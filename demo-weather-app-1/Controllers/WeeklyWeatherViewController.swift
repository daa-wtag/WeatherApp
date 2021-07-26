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
    var weeklyWeatherData:WeeklyWeatherData?
    var apiCallingStruct = ApiCallingStruct()
    var didFindLocation:Bool?
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didFindLocation = false
        tableView.dataSource = self
        apiCallingStruct.weeklyWeatherDelegate = self
        
        if let lat = latitude , let lon = longitude{
            apiCallingStruct.callApi(latitude: lat, longitude: lon, isWeeklyForcast: true)
        }
    }
}

//MARK:- ApiCallingStructDelegate
extension WeeklyWeatherViewController:ApiCallingStructDelegateWeekly{
    func passWeeklyJsonDataAsStruct(weeklyWeatherData: WeeklyWeatherData) {
        self.weeklyWeatherData = weeklyWeatherData
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK:- UITableViewDataSource
extension WeeklyWeatherViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = ( weeklyWeatherData?.daily.count ?? 1 ) - 1
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.weatherCellIdentifier, for: indexPath) as! WeeklyWeatherCell
        
        if let dailyWeather = weeklyWeatherData?.daily[indexPath.row + 1]{
            cell.updateCell(dailyWeather: dailyWeather, dayOfTheWeek: indexPath.row + 1)
        }
        cell.backgroundColor = UIColor(named: Constants.appBackGroundColor)
        return cell
    }
}
//
//  WeeklyView Controller.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 14/7/21.
//

import UIKit
import CoreLocation

class NextSevenDaysWeatherViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var nextSevenDaysWeatherData: NextSevenDaysWeatherData?
    var apiCallingStruct = ApiCallingStruct()
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        apiCallingStruct.weatherDelegate = self
        tableView.tableFooterView = UIView()
        if let lat = latitude , let lon = longitude{
            apiCallingStruct.callApi(latitude: lat, longitude: lon, isWeeklyForcast: true)
        }
    }
    
    deinit {
        print(" NextSevenDaysWeatherViewController is deallocated")
    }
}

//MARK:- ApiCallingStructDelegate
extension NextSevenDaysWeatherViewController: ApiCallingStructDelegate{
    func updateUI(_ apiCallingStruct: ApiCallingStruct,weatherData:Codable) {
        self.nextSevenDaysWeatherData = weatherData as? NextSevenDaysWeatherData
        print("Updated UI in \(#file):\(#line)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK:- UITableViewDataSource
extension NextSevenDaysWeatherViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = ( nextSevenDaysWeatherData?.daily.count ?? 1 ) - 1
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.weatherCellIdentifier, for: indexPath) as! WeeklyWeatherCell
        
        if let dailyWeather = nextSevenDaysWeatherData?.daily[indexPath.row + 1]{
            cell.updateCell(dailyWeather: dailyWeather, dayOfTheWeek: indexPath.row + 1)
        }
        cell.backgroundColor = UIColor(named: Constants.appBackGroundColor)
        
        return cell
    }
}


extension NextSevenDaysWeatherViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    let detailsOfDailyWeatherVC =  storyboard?.instantiateViewController(withIdentifier: Constants.detailsOfDailyWeatherIdentifier) as! DetailsOfDailyWeatherViewController
      // passing data to next vc [S]
        let dailyWeather = nextSevenDaysWeatherData?.daily[indexPath.row + 1]
        detailsOfDailyWeatherVC.dailyWeather = dailyWeather
        if let theDate = dailyWeather?.dt{
            detailsOfDailyWeatherVC.theDate = theDate.getDate(atDDMMMformat: true)
        }
     // passing data to next vc [E]
        navigationController?.pushViewController(detailsOfDailyWeatherVC, animated: true)
    }
}

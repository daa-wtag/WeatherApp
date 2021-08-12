//
//  DetailsOfDailyWeather.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 27/7/21.
//

import UIKit

class DetailsOfDailyWeatherViewController: UIViewController {
    @IBOutlet weak var xDayDetailsLabel: UILabel!
    @IBOutlet weak var sunriseImageView: UIImageView!
    @IBOutlet weak var sunsetImageView: UIImageView!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var moonRiseImageView: UIImageView!
    @IBOutlet weak var moonRiseLabel: UILabel!
    @IBOutlet weak var moonSetImageView: UIImageView!
    @IBOutlet weak var moonSetLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    var dailyWeather: DailyWeather?
    var theDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        xDayDetailsLabel.text = theDate! + "'s Details"
        sunriseImageView.image = UIImage(systemName: "sunrise")
        sunsetImageView.image = UIImage(systemName: "sunset")
        moonRiseImageView.image = UIImage(named: "moonrise")
        moonSetImageView.image = UIImage(named: "moonset")
        
        if let dailyWeather = dailyWeather{
            sunriseLabel.text = dailyWeather.sunrise.getDate(atDDMMMformat: false)
            sunsetLabel.text = dailyWeather.sunset.getDate(atDDMMMformat: false)
            moonRiseLabel.text = dailyWeather.moonrise.getDate(atDDMMMformat: false)
            moonSetLabel.text = dailyWeather.moonset.getDate(atDDMMMformat: false)
            if let lastWeather = dailyWeather.weather.last{
                weatherDescriptionLabel.text = lastWeather.main
            }
            maxTempLabel.text = String(format:"%.1f",dailyWeather.temp.max) + "°C"
            minTempLabel.text = String(format:"%.1f",dailyWeather.temp.min) + "°C"
            windSpeedLabel.text = String(format:"%.1f",dailyWeather.wind_speed) + "m/s"
            humidityLabel.text = String(dailyWeather.humidity) + "%"
        }
    }
    
    deinit {
        print("DetailsOfDailyWeatherViewController is deallocated - -")
    }
}

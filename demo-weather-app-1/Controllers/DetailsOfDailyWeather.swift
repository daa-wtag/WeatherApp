// Hello peter
//  DetailsOfDailyWeather.swift
//  demo-weather-app-1
//
//  Created by Abdullah M ohammad Daihan on 27/7/21.
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
    var theDate:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("-")
        
    }

}

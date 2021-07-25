//
//  WeatherViewCell.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 25/7/21.
//

import UIKit

class WeatherViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var dividerLabel: UIView!
    
    func updateCell(dailyWeather:WeeklyJsonDataAsStruct.Daily,dayOfTheWeek:Int){
        if dayOfTheWeek == 1{
            dateLabel.text = "Tomorrow"
        }else{
            dateLabel.text = getDate(from: dailyWeather.dt )
        }
        tempLabel.text = String(format:"%.1f",dailyWeather.temp.max) + "°C"
        if let imageLogoID = dailyWeather.weather.last?.icon{
          imageLabel.downloaded(from: "https://openweathermap.org/img/wn/\(imageLogoID)@2x.png")
        }
        
        if dayOfTheWeek == 7{
            dividerLabel.isHidden = true
        }
    }
    
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

//
//  WeatherViewCell.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 25/7/21.
//

import UIKit

class WeeklyWeatherCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var WeeklyWeatherCellImageView: UIImageView!
    @IBOutlet weak var dividerLabel: UIView!
    
    func updateCell(dailyWeather: DailyWeather, dayOfTheWeek: Int){
        if dayOfTheWeek == 1{
            dateLabel.text = "Tomorrow"
        }else{
            dateLabel.text = dailyWeather.dt.getDate(atDDMMMformat: true)
        }
        tempLabel.text = String(format:"%.1f",dailyWeather.temp.max) + "°C"
        
        if let uiImage = UIImage(systemName: Constants.weatherIcon(temp: dailyWeather.temp.max))?.resize(100,100){
          WeeklyWeatherCellImageView.image = uiImage
        }
//        if let imageLogoID = dailyWeather.weather.last?.id{
//            let imageIconUrl = "\(Constants.iconDownloadingBaseUrl)\(imageLogoID)@2x.png"
//          //imageLabel.downloaded(from: imageIconUrl)
//
//        }
        
        //if dayOfTheWeek == 7{
            dividerLabel.isHidden = true
       // }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 15))
    }
}

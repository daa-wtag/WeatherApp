//
//  Double.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 27/7/21.
//

import Foundation
extension Double{
    func getDate(atDDMMMformat:Bool) -> String {
        let dt = self
        let date = NSDate(timeIntervalSince1970: dt) // Jul 27, 2021 at 6:43 PM for 1627389833
        //Date formatting
        let dayTimePeriodFormatter = DateFormatter()
        //dayTimePeriodFormatter.dateFormat = "dd/M/YYYY" // 27/7/2021
        if atDDMMMformat{
            dayTimePeriodFormatter.dateFormat = "dd MMM" // 27 Jul
        }else{
          dayTimePeriodFormatter.dateFormat = "h:mm a" // 6:43 PM
        }
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
}

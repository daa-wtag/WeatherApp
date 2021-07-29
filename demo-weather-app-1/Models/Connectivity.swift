//
//  Connectivity.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 29/7/21.
//

import Foundation
import Alamofire
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

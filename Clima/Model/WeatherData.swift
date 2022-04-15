//
//  WeatherData.swift
//  Clima
//
//  Created by Jonathan De Araújo Silva on 07/02/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
    
struct MainData: Decodable {
    let temp: Double
}

struct Weather : Decodable {
    let id: Int
}

struct WeatherData: Decodable {
    let name: String
    let main: MainData
    let weather: [Weather]
}

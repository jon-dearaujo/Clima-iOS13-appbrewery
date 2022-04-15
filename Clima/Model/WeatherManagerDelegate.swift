//
//  WeatherManagerDelegate.swift
//  Clima
//
//  Created by Jonathan De Araújo Silva on 07/02/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didWeatherUpdate(_ data: WeatherModel?)
    func didCompleteWithError(_ error: String?)
}

//
//  WeatherManager.swift
//  Clima
//
//  Created by Jonathan De Araújo Silva on 06/01/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    
    let WeatherURL =
        "https://api.openweathermap.org/data/2.5/weather?appid=fcb64fd3609c88744bd8a4c5d8c23da9&units=metric"
    
    func fetchWEather(cityName: String) {
        let urlString = "\(WeatherURL)&q=\(cityName.replacingOccurrences(of: " ", with: "+"))"
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(lat: Double, long: Double) {
        let urlString = "\(WeatherURL)&lat=\(lat)&lon=\(long)"
        performRequest(urlString: urlString)
    }
    
    var delegate: WeatherManagerDelegate?
    
    private func performRequest(urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didCompleteWithError("Error loading data \(error!)")
                    return
                }
                
                if let safeData = data {
                    delegate?.didWeatherUpdate(parseJSON(weatherData: safeData))
                }
            }
            task.resume()
        } else {
            delegate?.didCompleteWithError("Error loading data for \(urlString)")
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            return WeatherModel(conditionId: decodedData.weather[0].id, cityName: decodedData.name, temperature: decodedData.main.temp)
            
        } catch {
            delegate?.didCompleteWithError("Error parsing data data")
            return nil
        }
    }
}

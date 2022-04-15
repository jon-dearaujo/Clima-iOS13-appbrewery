//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationSearchButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var loadingSpinnerView: UIActivityIndicatorView!
    @IBOutlet weak var contentContainer: UIStackView!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    var location: CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        locationSearchButton.isEnabled = false
        
        loadingSpinnerView.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.requestLocation()
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations[0]
        locationSearchButton.isEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController : UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    @IBAction func locationSearchPressed(_ sender: UIButton) {
        if let safeLocation = location {
            didStartLoading()
            weatherManager.fetchWeather(lat: safeLocation.coordinate.latitude, long: safeLocation.coordinate.longitude)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        
        textField.placeholder = "Type something"
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        didStartLoading()
        weatherManager.fetchWEather(cityName: textField.text!)
        textField.text = ""
    }
    
    func didStartLoading() {
        view.bringSubviewToFront(loadingSpinnerView)
        loadingSpinnerView.isHidden = false
        locationSearchButton.isEnabled = false
        searchButton.isEnabled = false
        searchTextField.isEnabled = false
        toggleDimContent(contentContainer, dim: true)
    }
    
    func didCompleteLoading() {
        view.sendSubviewToBack(loadingSpinnerView)
        loadingSpinnerView.isHidden = true
        locationSearchButton.isEnabled = true
        searchButton.isEnabled = true
        searchTextField.isEnabled = true
        toggleDimContent(contentContainer, dim: false)
    }
    
    func toggleDimContent(_ view: UIView, dim: Bool) {
        view.layer.opacity = dim ? 0.25 : 1
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didWeatherUpdate(_ data: WeatherModel?) {
        DispatchQueue.main.async {
            if data != nil {
                self.cityLabel.text = data?.cityName
                self.temperatureLabel.text = data?.temperatureString
                self.conditionImageView.image = UIImage(systemName: data!.conditionName)
            }
            self.didCompleteLoading()
        }
    }
    
    func didCompleteWithError(_ error: String?) {
        print(error!)
        DispatchQueue.main.async {
            self.didCompleteLoading()
        }
    }
}

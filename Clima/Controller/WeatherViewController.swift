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
    
    var dataLoader = LoadManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        dataLoader.delegate = self
        searchTextField.delegate = self
        
    }
    
    @IBAction func buttonLocation(_ sender: Any) {
        locationManager.requestLocation()
        
    }
    
    
}




extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func senderPress(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else {
            textField.placeholder = "SaySomething"
            return false
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            dataLoader.fecthWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
    
    
    
}

extension WeatherViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(_ dataLoader: LoadManager, weather : weatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.getTemperture
            self.conditionImageView.image = UIImage(systemName: weather.getConditionsName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

extension WeatherViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager:  CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        print("get location")
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            
            dataLoader.fecthWeather(latitude: lat, longitude: long)
            print(lat)
            print(long)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
    }
    
}

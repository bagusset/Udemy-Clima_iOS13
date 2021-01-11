//
//  LoadManager.swift
//  Clima
//
//  Created by Bagus setiawan on 23/08/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ dataLoader: LoadManager, weather : weatherModel)
    func didFailWithError(error: Error)
}

struct LoadManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=19e86e5c0eb9ad77f9a44d4e8fd520d8&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fecthWeather(cityName : String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
        print(urlString)
    }
    
    func fecthWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    
    func performRequest( urlString : String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil{
                        self.delegate?.didFailWithError(error: error!)
                        print(error!)
                        return
                    }
                    
                    if let safeData = data{
                        if let weather = self.parseJSON(weatherData: safeData) {
                            self.delegate?.didUpdateWeather(self, weather: weather)
                        }
                    }
                }
            task.resume()
            
        }
    }
    
    func parseJSON(weatherData: Data) -> weatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let city = decodedData.name
            
            let weather = weatherModel(conditionID: id, cityName: city, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
   
}

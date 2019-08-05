//
//  WeatherViewController.swift
//  News
//
//  Created by Anna Bibyk on 8/2/19.
//  Copyright © 2019 Anna Bibyk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class WeatherViewController: UIViewController {

    let weatherURL = "http://api.openweathermap.org/data/2.5/weather"
    let appID = "e72ca729af228beabd5d20e3b7749713"
    var city = ""

    let weatherData = WeatherData()
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retriveCity()
    }
    
    // MARK: - Fetching user city info from database
    
    func retriveCity() {
        let uid = Auth.auth().currentUser?.uid
        _ = Database.database().reference().child("Users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Dictionary<String, String> {
                print("!!!")
                self.city = value["City"]!
                let params : [String : String] = ["q" : self.city, "appid" : self.appID]
                
                self.getWeatherData(url: self.weatherURL, parameters: params)
                
            }
        }
    }
    
    // MARK: - Networking
    
    func getWeatherData(url : String, parameters : [String : String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("Error - \(String(describing: response.result.error))")
                self.cityLabel.text = "Error Connection Issues"
            }
        }
    }
    
    // MARK: - JSON Parsing
  
    func updateWeatherData(json : JSON) {
        
        if let tempResult = json["main"]["temp"].double {
            
            weatherData.temperature = Int(tempResult - 273.15)
            
            weatherData.city = json["name"].stringValue
            
            weatherData.condition = json["weather"][0]["id"].intValue
            
            weatherData.weatherIconName = weatherData.updateWeatherIcon(condition: weatherData.condition)
            
            updateUIWithWeatherData()
        } else {
            cityLabel.text = "City not found"
        }
    }
 
    // MARK: - UI Updates
    
    func updateUIWithWeatherData() {
        
        cityLabel.text = weatherData.city
        temperatureLabel.text = String("\(weatherData.temperature)°")
        weatherIcon.image = UIImage(named: weatherData.weatherIconName)
    }
}

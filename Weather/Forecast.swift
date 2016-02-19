//
//  Forecast.swift
//  Weather
//
//  Created by Shelby Jestin on 2016-02-09.
//  Copyright © 2016 Shelby Jestin. All rights reserved.
//
//  This class holds the object for Forecast, which contains all relevant
//  data for future forecasts from OpenWeatherMaps' API
//

import Foundation

class Forecast: NSObject {
    
    // VALUES FROM OPENWEATHERMAPS
    var day: String
    var temperature: String
    var max: String
    var min: String
    var weather: String
    var pressure: String
    var visibility: String
    var humidity: String
    var wind: String
    var precipitation: String
    
    override init() {
        day = ""
        temperature = ""
        max = ""
        min = ""
        weather = ""
        pressure = ""
        visibility = ""
        humidity = ""
        wind = ""
        precipitation = ""
    }
    
    // INITIATE FORECAST WITH VALUES
    init(day: String, temperature: String, max: String, min: String,
        weather: String, pressure: String, visibility: String, humidity: String,
        wind: String, precipitation: String) {
        self.day = day
        self.temperature = temperature
        self.max = max
        self.min = min
        self.weather = weather
        self.pressure = pressure
        self.visibility = visibility
        self.humidity = humidity
        self.wind = wind
        self.precipitation = precipitation
    }
    
    // RETURN ICON WITH ASSOCIATED VALUE
    func getIcon(icon: Int) -> String {
        if icon >= 200 && icon < 300 {
            return "11d"
        }
        else if icon >= 300 && icon < 400 {
            return "09d"
        }
        else if icon >= 500 && icon < 600 {
            if icon <= 504 {
                return "10d"
            }
            else if icon == 511 {
                return "13d"
            }
            else if icon >= 521 {
                return "09d"
            }
        }
        else if icon >= 600 && icon < 700 {
            return "13d"
        }
        else if icon >= 700 && icon < 800 {
            return "50d"
        }
        else if icon >= 800 && icon < 900{
            switch icon {
            case 800:
                return "01d"
            case 801:
                return "02d"
            case 802:
                return "03d"
            case 803:
                return "03d"
            case 804:
                return "04d"
            default: break
            }
        }
        return ""
    }
}
//
//  Weather.swift
//  Weather
//
//  Created by Shelby Jestin on 2016-02-09.
//  Copyright © 2016 Shelby Jestin. All rights reserved.
//
//  This class holds the object for Weather, which contains all relevant
//  data for current weather from OpenWeatherMaps' API

import Foundation

class Weather: NSObject {
    
    // VALUES FROM OPENWEATHERMAPS
    var city: String
    var country: String
    var temperature: String
    var weather: String
    var pressure: String
    var visibility: String
    var humidity: String
    var wind: String
    var precipitation: String
    
    override init() {
        city = ""
        country = ""
        temperature = ""
        weather = ""
        pressure = ""
        visibility = ""
        humidity = ""
        wind = ""
        precipitation = ""
    }
    
    // INITIATE WEATHER WITH VALUES
    init(city: String, country: String, temperature: String, weather: String,
        pressure: String, visibility: String, humidity: String, wind: String,
        precipitation: String) {
        self.city = city
        self.country = country
        self.temperature = temperature
        self.weather = weather
        self.pressure = pressure
        self.visibility = visibility
        self.humidity = humidity
        self.wind = wind
        self.precipitation = precipitation
    }
}

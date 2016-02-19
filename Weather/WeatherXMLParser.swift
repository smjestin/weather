//
//  WeatherXMLParser.swift
//  Weather
//
//  Created by Shelby Jestin on 2016-02-09.
//  Copyright © 2016 Shelby Jestin. All rights reserved.
//
//  This class is used to parse XML from OpenWeatherMaps' current weather,
//  which shows all information for a particular location's weather. It takes in
//  the required XML file, parses it, and places the information in a Weather
//  object. 
//

import Foundation

class WeatherXMLParser: NSObject, NSXMLParserDelegate {
    
    // WEATHER ELEMENTS
    var city: String!
    var country: String!
    var temperature: String!
    var weather: String!
    var pressure: String!
    var visibility: String!
    var humidity: String!
    var wind: String!
    var precipitation: String!
    
    let currentWeather = Weather.init()
    var currentParsedElement = String()
    var weAreInsideAnItem = false
    var done = false
    
    var xmlParser: NSXMLParser!
    
    // OPEN URL AND BEGIN XML PARSING: NO GPS
    func weatherSearch(city: String) {
        done = false
        
        // open URL
        let urlString = NSURL(string:
            "http://api.openweathermap.org/data/2.5/weather?id=" + city + "&appid=b799eb65f142c32b21089fa8cc5d2ca0&mode=xml&units=metric")
        let rssUrlRequest:NSURLRequest = NSURLRequest(URL:urlString!)
        let queue:NSOperationQueue = NSOperationQueue()
        
        // begin parsing
        NSURLConnection.sendAsynchronousRequest(rssUrlRequest, queue: queue) {
            (response, data, error) -> Void in
            self.xmlParser = NSXMLParser(data: data!)
            self.xmlParser.delegate = self
            self.xmlParser.parse()
        }
        
        // lock until parsing is done
        while(!done) {}
    }
    
    // OPEN URL AND BEGIN XML PARSING: GPS
    func weatherSearch(longitude: String, latitude: String) {
        done = false
        
        // open URL
        let urlString = NSURL(string:
            "http://api.openweathermap.org/data/2.5/weather?lat=" + latitude
                + "&lon=" + longitude +
            "&appid=b799eb65f142c32b21089fa8cc5d2ca0&mode=xml&units=metric")
        let rssUrlRequest:NSURLRequest = NSURLRequest(URL:urlString!)
        let queue:NSOperationQueue = NSOperationQueue()
        
        // begin parsing
        NSURLConnection.sendAsynchronousRequest(rssUrlRequest, queue: queue) {
            (response, data, error) -> Void in
            self.xmlParser = NSXMLParser(data: data!)
            self.xmlParser.delegate = self
            self.xmlParser.parse()
        }
        
        // lock until parsing is done
        while(!done) {}
    }
    
    // PARSE THROUGH XML
    func parser(parser: NSXMLParser,didStartElement elementName: String,
        namespaceURI: String?, qualifiedName qName: String?,
        attributes attributeDict: [String : String]) {
            if elementName == "current" {   // check if tag is "current"
                weAreInsideAnItem = true
            }
            if weAreInsideAnItem {  // locate desired tags
                switch elementName {
                case "city":
                    city = attributeDict["name"]! as String
                    currentParsedElement = "city"
                case "country":
                    country = String()
                    currentParsedElement = "country"
                case "temperature":
                    temperature = attributeDict["value"]! as String
                    currentParsedElement = "temperature"
                case "humidity":
                    if let value = attributeDict["value"] {
                        humidity = value as String
                        humidity = humidity + attributeDict["unit"]! as String }
                    else { humidity = "-" }
                    currentParsedElement = "humidity"
                case "pressure":
                    if let value = attributeDict["value"] {
                        pressure = value as String
                        pressure = pressure + attributeDict["unit"]! as String }
                    else { pressure = "-" }
                    currentParsedElement = "pressure"
                case "speed":
                    if let value = attributeDict["value"] {
                        wind = value as String }
                    else { wind = "-" }
                    currentParsedElement = "wind"
                case "visibility":
                    if let value = attributeDict["value"] {
                        visibility = value as String }
                    else { visibility = "-" }
                    currentParsedElement = "visibility"
                case "precipitation":
                    if let value = attributeDict["value"] {
                        precipitation = value as String }
                    else { precipitation = "-" }
                    currentParsedElement = "precipitation"
                case "weather":
                    weather = attributeDict["icon"]
                    currentParsedElement = "weather"
                default: break
                }
            }
    }
    
    // PARSE XML AND ASSOCIATE WITH VALUES
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if weAreInsideAnItem {
            switch currentParsedElement {
                case "city":
                    city = city + string
                case "country":
                    country = country + string
                case "temperature":
                    temperature = temperature + string
                case "weather":
                    weather = weather + string
                case "precipitation":
                    precipitation = precipitation + string
                case "pressure":
                    pressure = pressure + string
                case "wind":
                    wind = wind + string
                case "humidity":
                    humidity = humidity + string
                case "visibility":
                    visibility = visibility + string
                default: break
            }
        }
    }
    
    // SET VALUES AFTER PARSING
    func parser(parser: NSXMLParser, didEndElement elementName: String,
        namespaceURI: String?, qualifiedName qName: String?) {
            if weAreInsideAnItem {
                switch elementName {
                case "city":
                    currentParsedElement = ""
                case "country":
                    currentParsedElement = ""
                case "temperature":
                    currentParsedElement = ""
                case "weather":
                    currentParsedElement = ""
                case "precipitation":
                    currentParsedElement = ""
                case "pressure":
                    currentParsedElement = ""
                case "wind":
                    currentParsedElement = ""
                case "humidity":
                    currentParsedElement = ""
                case "visibility":
                    currentParsedElement = ""
                default: break
                }
                if elementName == "current" {
                    currentWeather.city = city
                    currentWeather.country = country
                    currentWeather.temperature = temperature
                    currentWeather.weather = weather
                    currentWeather.precipitation = precipitation
                    currentWeather.pressure = pressure
                    currentWeather.wind = wind
                    currentWeather.humidity = humidity
                    currentWeather.visibility = visibility
                    weAreInsideAnItem = false
                }
            }
    }
    
    // UNLOCK WHEN END OF DOCUMENT
    func parserDidEndDocument(parser: NSXMLParser) {
        done = true
    }
}

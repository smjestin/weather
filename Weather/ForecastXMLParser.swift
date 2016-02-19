//
//  ForecastXMLParser.swift
//  Weather
//
//  Created by Shelby Jestin on 2016-02-09.
//  Copyright © 2016 Shelby Jestin. All rights reserved.
//
//  This class is used to parse XML from OpenWeatherMaps' long-term forecast,
//  which shows all information for a particular number of days. It takes in 
//  the required XML file, parses it, and places the information for a given 
//  day in its associated Forecast object.
//

import Foundation

class ForecastXMLParser: NSObject, NSXMLParserDelegate {
    
    // FORECAST ELEMENTS
    var city: String!
    var day: String!
    var temperature: String!
    var max: String!
    var min: String!
    var weather: String!
    var pressure: String!
    var humidity: String!
    var wind: String!
    var precipitation: String!
    
    // FORECAST DAYS
    let day1Weather = Forecast.init()
    let day2Weather = Forecast.init()
    let day3Weather = Forecast.init()
    let day4Weather = Forecast.init()
    let day5Weather = Forecast.init()
    let day6Weather = Forecast.init()
    
    var currentParsedElement = String()
    var weAreInsideAnItem = false
    var done = false                    // checks if parsing is complete
    var count = 0                       // determines day
    var xmlParser: NSXMLParser!
    
    // OPEN URL AND BEGIN XML PARSING: NO GPS
    func forecastSearch(city: String) {
        done = false
        count = 0
        
        // open URL
        let urlString = NSURL(string:
            "http://api.openweathermap.org/data/2.5/forecast/daily?id=" + city + "&mode=xml&units=metric&cnt=7&appid=44db6a862fba0b067b1930da0d769e98")
        let rssUrlRequest:NSURLRequest = NSURLRequest(URL:urlString!)
        let queue:NSOperationQueue = NSOperationQueue()
        
        // begin parsing
        NSURLConnection.sendAsynchronousRequest(rssUrlRequest, queue: queue) {
            (response, data, error) -> Void in
            self.xmlParser = NSXMLParser(data: data!)
            self.xmlParser.delegate = self
            self.xmlParser.parse()
        }
        
        while(!done) {} // lock until done
    }
    
    // OPEN URL AND BEGIN XML PARSING: GPS
    func forecastSearch(longitude: String, latitude: String) {
        done = false
        count = 0
        
        // open URL
        let urlString = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?lat=" +
            latitude + "&lon=" + longitude
            + "&mode=xml&units=metric&cnt=7&appid=44db6a862fba0b067b1930da0d769e98")
        let rssUrlRequest:NSURLRequest = NSURLRequest(URL:urlString!)
        let queue:NSOperationQueue = NSOperationQueue()
        
        // begin parsing
        NSURLConnection.sendAsynchronousRequest(rssUrlRequest, queue: queue) {
            (response, data, error) -> Void in
            self.xmlParser = NSXMLParser(data: data!)
            self.xmlParser.delegate = self
            self.xmlParser.parse()
        }
        
        while(!done) {} // lock until done
    }
    
    // PARSE THROUGH XML
    func parser(parser: NSXMLParser,didStartElement elementName: String,
        namespaceURI: String?, qualifiedName qName: String?,
        attributes attributeDict: [String : String]) {
        if elementName == "time" {      // if tag begins with time, enter item
            weAreInsideAnItem = true
        }
        if weAreInsideAnItem {      // locate time tags
            switch elementName {
            case "time":
                day = attributeDict["day"]! as String
                currentParsedElement = "city"
            case "symbol":
                weather = attributeDict["number"]
                currentParsedElement = "symbol"
            case "precipitation":
                if let value = attributeDict["value"] {
                    precipitation = value as String + " mm"
                    precipitation = precipitation + " of " +
                        attributeDict["type"]! as String}
                else { precipitation = "-" }
                currentParsedElement = "precipitation"
            case "windSpeed":
                if let value = attributeDict["mps"] {
                    wind = value as String }
                else { wind = "-" }
                currentParsedElement = "wind"
            case "temperature":
                temperature = attributeDict["day"]! as String
                max = attributeDict["max"]! as String
                min = attributeDict["min"]! as String
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
            default: break
            }
        }
    }
    
    
    // PARSE XML AND ASSOCIATE WITH VALUES
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if weAreInsideAnItem {
            switch currentParsedElement {
            case "time":
                day = day + string
            case "temperature":
                temperature = temperature + string
                max = max + string
                min = min + string
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
            default: break
            }
        }
    }
    
    // SET VALUES AFTER PARSING
    func parser(parser: NSXMLParser, didEndElement elementName: String,
        namespaceURI: String?, qualifiedName qName: String?) {
        if weAreInsideAnItem {
            switch elementName {
            case "time":
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
            default: break
            }
            // place values into associated Forecast
            if elementName == "time" {
                switch count {
                case 1:
                    setValues(day1Weather)
                case 2:
                    setValues(day2Weather)
                case 3:
                    setValues(day3Weather)
                case 4:
                    setValues(day4Weather)
                case 5:
                    setValues(day5Weather)
                case 6:
                    setValues(day6Weather)
                default:break
                }
                count++
                weAreInsideAnItem = false
            }
        }
    }
    
    // SET VALUES INTO FORECAST
    func setValues(forecast: Forecast) {
        forecast.day = day
        forecast.temperature = temperature
        forecast.max = max
        forecast.min = min
        forecast.weather = weather
        forecast.pressure = pressure
        forecast.humidity = humidity
        forecast.wind = wind
        forecast.precipitation = precipitation
    }
    
    // STOP PARSING ONCE END OF DOCUMENT IS REACHED
    func parserDidEndDocument(parser: NSXMLParser) {
        done = true
    }
    
}
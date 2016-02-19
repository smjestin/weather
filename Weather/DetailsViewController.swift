//
//  ViewController.swift
//  Weather
//
//  Created by Shelby Jestin on 2016-02-07.
//  Copyright © 2016 Shelby Jestin. All rights reserved.
//
//  This class shows further details of the individual Forecast and Weather
//  elements, including pressure, humidity, visibility, etc. 
//

import UIKit

class DetailsViewController: UIViewController {

    var weather: Weather!
    var forecast: Forecast!
    var city: String!
    var date: String!
    
    // LABELS
    @IBOutlet weak var pressureLabel: UITextField!
    @IBOutlet weak var visibilityLabel: UITextField!
    @IBOutlet weak var humidityLabel: UITextField!
    @IBOutlet weak var windLabel: UITextField!
    @IBOutlet weak var precipitationLabel: UITextField!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var maxMinLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // organize appearance of labels
        dateLabel.numberOfLines = 1;
        dateLabel.minimumScaleFactor = 0.5;
        dateLabel.adjustsFontSizeToFitWidth = true;
        tempLabel.numberOfLines = 1;
        tempLabel.minimumScaleFactor = 0.5;
        tempLabel.adjustsFontSizeToFitWidth = true;

        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        
        locationLabel.text = "in " + city
        
        // associated labels if this is a Weather detail view
        if weather != nil {
            tempLabel.text = String(Int(Double(weather.temperature)!)) + "\u{00B0}" + "C"
            weatherIcon.image = UIImage(named: weather.weather + ".png")
            dateLabel.text = date
            maxMinLabel.hidden = true
            
            visibilityLabel.attributedText = boldText("Visibility: \t", label:
                weather.visibility)
            pressureLabel.attributedText = boldText("Pressure: \t", label:
                weather.pressure)
            humidityLabel.attributedText = boldText("Humidity: \t", label:
                weather.humidity)
            windLabel.attributedText = boldText("Wind: \t", label:
                toKMPerHour(Double(weather.wind)!) + " km/h")
            precipitationLabel.attributedText = boldText("Precipitation: \t",
                label: weather.precipitation)
        }
            
        // associated labels if this is a Forecast detail view
        else if forecast != nil {
            tempLabel.text = String(Int(Double(forecast.temperature)!)) + "\u{00B0}" + "C"
            weatherIcon.image = UIImage(named: forecast.getIcon(Int(forecast.weather)!) + ".png")
            dateLabel.text = date + ", " + getDay(forecast.day)
            maxMinLabel.text = "high " + String(Int(Double(forecast.max)!)) +
                "\u{00B0}" + "C" + "\t/\tlow " + String(Int(Double(forecast.min)!))
                + "\u{00B0}" + "C"
            
            visibilityLabel.hidden = true
            pressureLabel.attributedText = boldText("Pressure: \t", label:
                forecast.pressure)
            humidityLabel.attributedText = boldText("Humidity: \t", label:
                forecast.humidity)
            windLabel.attributedText = boldText("Wind: \t", label:
                toKMPerHour(Double(forecast.wind)!) + " km/h")
            precipitationLabel.attributedText = boldText("Precipitation: \t",
                label: forecast.precipitation)
        }
        print(tempLabel.text)
    }

    // CHANGES TEXT TO BOLDED TITLE
    func boldText(title: String, label: String) -> NSMutableAttributedString {
        let boldAttributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(22)]
        let attributedString = NSMutableAttributedString(string:title, attributes:boldAttributes)
        let labelText = NSMutableAttributedString(string:label, attributes: nil)
        attributedString.appendAttributedString(labelText)
        return attributedString
    }
    
    // RETURN DATE IN PLAIN ENGLISH FROM NUMBER
    func getDay(date: String) -> String {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // received date foramt
        let todayDate = formatter.dateFromString(date)!
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        // return components of date
        let components = calendar.components([.Day , .Month , .Year], fromDate: todayDate)
        
        let month = components.month
        var stringMonth = ""
        let day = components.day
        
        // determine month based on associated number
        switch month {
        case 1:
            stringMonth = "January"
        case 2:
            stringMonth = "February"
        case 3:
            stringMonth = "March"
        case 4:
            stringMonth = "April"
        case 5:
            stringMonth = "May"
        case 6:
            stringMonth = "June"
        case 7:
            stringMonth = "July"
        case 8:
            stringMonth = "August"
        case 9:
            stringMonth = "September"
        case 10:
            stringMonth = "October"
        case 11:
            stringMonth = "November"
        case 12:
            stringMonth = "December"
        default:break
        }
        
        return stringMonth + " " + String(day) + "th"
    }
    
    // CALCULATES KM/H FROM MPH
    func toKMPerHour(speed: Double) -> String {
        return String(speed * 1.609)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


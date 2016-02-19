//
//  ViewController.swift
//  Weather
//
//  Created by Shelby Jestin on 2016-02-07.
//  Copyright © 2016 Shelby Jestin. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    let weatherResults = WeatherXMLParser.init()
    let forecastResults = ForecastXMLParser.init()
    var locationManager = CLLocationManager()
    
    var latitude: String!
    var longitude: String!
    var city: String!
    var currentForecast = Forecast.init()
    
    @IBOutlet weak var locationButton: UIBarButtonItem!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var forecast: UITableView!
    @IBOutlet weak var wait: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start locationManager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        noTemperatureDisplay()  // wait until location is loaded
        
        //format navigation controller
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        
        // insert gesture recognition
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "pushAction")
        switchButton.addGestureRecognizer(tap)
        switchButton.userInteractionEnabled = true
    }
    
    // HIDE ALL ELEMENTS IF LOCATION NOT LOADED
    func noTemperatureDisplay() {
        wait.startAnimating()
        forecast.hidden = true
        location.hidden = true
        switchButton.hidden = true
        weatherIcon.hidden = true
        temperature.hidden = true
    }
    
    // FORMAT DISPLAY WHEN LOCATION IS FOUND
    func formatTemperatureDisplay() {
        // if no data available, send to put in location
        if city == nil && (longitude == nil || latitude == nil) {
            self.performSegueWithIdentifier("locationSender", sender: locationButton)
        }
        // if no longitude/latitude
        else if city != nil {
            weatherResults.weatherSearch(city)
            forecastResults.forecastSearch(city)
        }
        // if longitude/latitude
        else {
            weatherResults.weatherSearch(longitude, latitude: latitude)
            forecastResults.forecastSearch(longitude, latitude: latitude)
        }
        
        location.text = weatherResults.currentWeather.city + ", " +
            weatherResults.currentWeather.country
        weatherIcon.image = UIImage(named: weatherResults.weather! + ".png")
        
        temperature.text = String(Int(Double(weatherResults.temperature)!)) + "\u{00B0}" + "C"
        forecast.reloadData()
        
        // show all elements
        forecast.hidden = false
        location.hidden = false
        switchButton.hidden = false
        weatherIcon.hidden = false
        temperature.hidden = false
        
        // center icons
        weatherIcon.contentMode = UIViewContentMode.ScaleAspectFit
        weatherIcon.contentMode = .Center
        
        // resizeable font
        temperature.minimumScaleFactor = 0.5
        temperature.adjustsFontSizeToFitWidth = true
        
        forecast.delegate = self
        forecast.dataSource = self
        forecast.scrollEnabled = false
        forecast.tableFooterView = UIView(frame: CGRectZero)
        forecast.separatorColor =  UIColor(white: 1, alpha: 0.3)
        
        wait.stopAnimating()    // stop animating wait symbol
        wait.hidden = true      // hide wait symbol
    }
    
    // ON CLICKING TABLEVIEW CELLS
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {  // send a given Forecast object
        case 0:
            currentForecast = forecastResults.day1Weather
        case 1:
            currentForecast = forecastResults.day2Weather
        case 2:
            currentForecast = forecastResults.day3Weather
        case 3:
            currentForecast = forecastResults.day4Weather
        case 4:
            currentForecast = forecastResults.day5Weather
        case 5:
            currentForecast = forecastResults.day6Weather
        default: break
        }
        self.performSegueWithIdentifier("forecastWeather", sender: forecast)
    }
    
    // CONFIGURE NUMBER OF SECTIONS
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // CONFIGURE NUMBER OF ROWS
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    // CONFIGURE TITLE OF FORECAST TABLEVIEW
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int)
        -> String? {
        return "Forecast"
    }
    
    // FORMAT HEADER OF FORECAST TABLEVIEW
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView,
        forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.whiteColor()
        view.tintColor = UIColor(white: 0, alpha: 0.0)
    }
    
    // FORMAT FORECAST TABLEVIEW CELLS
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:
        NSIndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell",
            forIndexPath: indexPath)    // get labelCells
        cell.selectionStyle = .None     // format cells
        cell.backgroundColor = UIColor(white: 0, alpha: 0.0)
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        
        if indexPath.section == 0 { // configure cell data based on row
            if indexPath.row == 0 {
                self.configureForecastCell(cell, forecast: forecastResults.day1Weather)
            }
            else if indexPath.row == 1 {
                self.configureForecastCell(cell, forecast: forecastResults.day2Weather)
            }
            else if indexPath.row == 2 {
                self.configureForecastCell(cell, forecast: forecastResults.day3Weather)
            }
            else if indexPath.row == 3 {
                self.configureForecastCell(cell, forecast: forecastResults.day4Weather)
            }
            else if indexPath.row == 4 {
                self.configureForecastCell(cell, forecast: forecastResults.day5Weather)
            }
            else {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0,
                    CGRectGetWidth(forecast.bounds));   // remove bottom edge
                self.configureForecastCell(cell, forecast: forecastResults.day6Weather)
            }
        }
        return cell
    }
    
    // CONFIGURE CELLS FOR THE FORECAST
    func configureForecastCell(cell: UITableViewCell, forecast: Forecast) {
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        cell.textLabel?.text = getWeekDay(forecast.day)
        cell.detailTextLabel?.text = String(Int(Double(forecast.temperature)!)) + "\u{00B0}" + "C"
        cell.imageView?.image = UIImage(named: forecast.getIcon(Int(forecast.weather)!) + ".png")
        cell.imageView?.contentMode = .ScaleAspectFit
    }
    
    // CONVERT FROM DATE TO DAY OF THE WEEK
    func getWeekDay(date: String) -> String{
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // format of incoming date
        let todayDate = formatter.dateFromString(date)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
        let weekDay = myComponents.weekday // get weekday
        switch weekDay {    // convert int weekday to readable value
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return ""
        }
    }
    
    // ON CLICKING BUTTON, GO TO SEGUE
    func pushAction() {
        self.performSegueWithIdentifier("currentWeather", sender: switchButton)
    }
    
    // CHECK FOR LOCATION, AND ASSOCIATE LOCATION TO LATITUDE/LONGITUDE
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        latitude = String(locValue.latitude)
        longitude = String(locValue.longitude)
        if latitude != nil && longitude != nil {
            formatTemperatureDisplay()
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    // IF AN ERROR OCCURS WHEN CHECKING LOCATION
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
        print(error)
        self.performSegueWithIdentifier("locationSender", sender: locationButton)
    }
    
    // REQUEST PERMISSION, AND ASSOCIATE LOCATION TO LATITUDE/LONGITUDE
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus
        status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    latitude = String(locationManager.location!.coordinate.latitude)
                    longitude = String(locationManager.location!.coordinate.longitude)
                }
            }
        }
    }
    
    // IF COMING BACK FROM LOCATIONVIEW
    @IBAction func unwind(segue: UIStoryboardSegue) {
        self.locationManager.stopUpdatingLocation() // stop checking location
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        formatTemperatureDisplay()
    }
    
    // SEGUE TO DETAILSVIEW
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "currentWeather"){  // go to details with weather
            let detailsVC:DetailsViewController = segue.destinationViewController
                as! DetailsViewController
            let data = weatherResults.currentWeather
            detailsVC.weather = data
            detailsVC.city = location.text
            detailsVC.date = "Today"
        }
        if (segue.identifier == "forecastWeather"){ // go to details with forecast
            let detailsVC:DetailsViewController = segue.destinationViewController
                as! DetailsViewController
            detailsVC.forecast = currentForecast
            detailsVC.weather = nil
            detailsVC.city = location.text
            detailsVC.date = getWeekDay(currentForecast.day)
        }
    }
}


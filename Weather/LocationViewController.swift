//
//  ViewController.swift
//  coreDataTutorial
//
//  Created by xjiang on 2016-02-07.
//  Copyright © 2016 xjiang. All rights reserved.
//
//  This class allows users to select a location from which to view the forecast,
//  displaying a table that reads all locations from Core Data and allowing
//  the user to search through the cities and select one.
//

import UIKit
import Foundation
import CoreData

class LocationViewController: UIViewController, UITableViewDataSource,
    UITableViewDelegate, UISearchBarDelegate {
    
    // UI item
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let managedContext = (UIApplication.sharedApplication().delegate as!
        AppDelegate).managedObjectContext
    var cities = [NSManagedObject]()
    var searchCities = [AnyObject]()
    var searchActive : Bool = false
    var filtered:[String] = []
    var city: String!
    
    // ON LOAD, READ CORE DATA
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // don't show empty cell
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // change navigation bar colour
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor();
        
        // read Core Data information for entity City
        let fetchRequest = NSFetchRequest(entityName: "City")
        do {
            // fetch cities into results
            let results = try managedContext.executeFetchRequest(fetchRequest)
            cities = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* THESE FUNCTIONS ARE CALLED WHEN USER IS EDITING */
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    /****************************************************/
    
    // READS VALUES FROM SEARCH BAR
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let entries : NSArray = cities
        
        // search for the value in name or country
        let predicate = NSPredicate(format:
            "name contains[c] %@ OR country contains[c] %@", searchText, searchText)
        
        // filter results accordingly
        searchCities = entries.filteredArrayUsingPredicate(predicate)
        
        // user is no longer searching
        if(searchCities.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        // reload table when found
        self.tableView.reloadData()
    }
    
    // RETURN NUMBER OF CITIES
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
        return searchCities.count
    }
    
    // SHOW CITY NAME, COUNTRY ON CELLS
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:
        NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CityCell",
            forIndexPath: indexPath)
        let city = searchCities[indexPath.row]
        cell.textLabel!.text = (city.valueForKey("name") as? String)! + ", " +
            (city.valueForKey("country") as? String)!
        return cell
    }
    
    // IF CELL IS SELECTED
    func tableView(tableView: UITableView, didSelectRowAtIndexPath
        indexPath: NSIndexPath) {
        // return to main view
        let cityInteger = searchCities[indexPath.row].valueForKey("id")!
        city = String(cityInteger)
        self.performSegueWithIdentifier("citySegue", sender: tableView)
    }
    
    // RETURN TO MAIN VIEW
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "citySegue"){
            let mainVC:MainViewController = segue.destinationViewController as!
                MainViewController
            let data = city     // new city ID to display in MainView
            mainVC.city = data
        }
    }
}


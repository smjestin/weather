## Synopsis

Assignment 3, in which an iOS app showing the weather is to be created, written in Swift. It is optimized for iPhones, and uses both Core Data and Core Location to enhance the experience for users. It utilizes the weather functionality enabled by OpenWeatherMaps, and pulls in both the XML files for current weather and forecasts, and has a converted-to-SQLite database from the text file provided by OpenWeatherMaps in order to generate a list of cities. 

## Features

The user is introduced to the current weather at their location; if the app is unable to find the location, then the user is prompted to select from a list of cities. Once a city is selected or found, the application will show the current weather, as well as the forecast for the upcoming six days; if any of these elements are selected, the user can see more details about that forecast. At any given time, the user can also select the “+” button at the top of the main screen to select from any of the 70,000+ cities, both Canadian and abroad, that the OpenWeatherMaps API provides. 

## Functionality

### Minimum Functionality
* User can see current weather
* User can see upcoming forecast
* User can click on any weather/forecast and see detailed explanation
* User can select a new location if they so choose
* If no location is selected by default, user is prompted to select on

### Bonus Functionality
* Current location is selected
 * By default, user is prompted to allow for the location to be determined
 * If permission is granted, app finds location by default
 * If an error occurs, user is prompted to instead select a new location
 * If a user selects a new location, location searching functionality is halted
* Randomized backgrounds are provided
* User can select not only Canadian locations, but also locations from anywhere in the world

## Known Bugs
* The main known bug is a “constraint” error that appears on execution of the application; while this does not appear to affect the functionality, it is present and presumably would need to be fixed in the future
* Views overlap each other on transition. While this is not actually a bug, it does affect the look of the application, as views contain transparent backgrounds and the transition is visible.

## Future Development
* Custom transition, wherein the views slide each other off screen






# TopStories
This is an application which loads a list of top stories. In addition, When a user taps on a storythen show a details view.


# Requirement
- XCode 14.0
- macOS Monterey 12.6.0

# Installation
## To run the project :

- Open TopStories.xcodeproj

# Language used 
- Swift 5.0

# App Version
- 1.0.0 
# Design Pattern Used

## VIPER
Viper is a design pattern that implements ‘separation of concern’ paradigm. Mostly like MVP or MVC it follows a modular approach. One feature, one module. For each module VIPER has five (sometimes four) different classes with distinct roles. No class go beyond its sole purpose. These classes are following.
-  View: Class that has all the code to show the app interface to the user and get their responses. Upon receiving a response View alerts the Presenter.
-  Presenter: Nucleus of a module. It gets user response from the View and work accordingly. Only class to communicate with all the other components. Calls the router for wire-framing, Interactor to fetch data (network calls or local data calls), view to update the UI.
-  Interactor: Has the business logics of an app. Primarily make API calls to fetch data from a source. Responsible for making data calls but not necessarily from itself.
-  Router : Does the wire-framing. Listens from the presenter about which screen to present and executes that.
-  Entity: Contains plain model classes used by the interactor.

![Viper](https://miro.medium.com/max/2862/1*-Mfew6qvLQ-t-DSOkY23Aw.png)

# Features

## List View 
- Shows a list of stories.

## Detail View
- shows additional information about the selected story. The user should see:
  *  Cover view
  *  Title
  *  Description
  *  Show More




# Assumptions        
-   The app is designed for iPhones and iPad.        
-   Mobile and iPad platform supported: iOS (12+)        
-   Device support : iPhone , iPad  


# Unit Test
* Test the behaviour, not the internal implementation





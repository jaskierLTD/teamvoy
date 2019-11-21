//
//  AppDelegate.swift
//  teamvoy
//
//  Created by Alessandro Marconi on 13/11/2019.
//  Copyright © 2019 OleksandrZheliezniak. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSServices.provideAPIKey("")
        GMSPlacesClient.provideAPIKey("")
        return true
        
    }
    
}


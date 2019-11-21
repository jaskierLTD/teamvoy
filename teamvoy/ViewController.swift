//
//  ViewController.swift
//  teamvoy
//
//  Created by Alessandro Marconi on 13/11/2019.
//  Copyright © 2019 OleksandrZheliezniak. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GooglePlaces
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, LocateOnTheMap {
    
    var jsonURLString = "https://api.sunrise-sunset.org/json?lat=48.50307386127209&lng=32.249835726558864"
    let locationManager = CLLocationManager()
    
    let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    let label4 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    let label5 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    let label6 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    let label7 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    let label8 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    let label9 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    let label10 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    let label11 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        jsonURLString = "https://api.sunrise-sunset.org/json?lat=\(locValue.latitude)&lng=\(locValue.longitude)"
    }
    
    // Setting-up the search bar
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    
    @IBAction func searchWithAddress(_ sender: AnyObject) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }
    
    func getCityLocation(lon: Double, andLatitude lat: Double, andTitle title: String){

        //print("CITY LOCATION FUNC")
        DispatchQueue.global(qos: .background).async {
        // Background Thread
        //print("POS BACKGROUND THREAD: \(lat), \(lon)")
        
            DispatchQueue.main.async {
            // Run UI Updates
            guard let url = URL(string: "https://api.sunrise-sunset.org/json?lat=\(lat)&lng=\(lon)") else { return }
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                 
                 guard let data = data else { return }
                 do {
                     let result = try JSONDecoder().decode(Result.self, from: data)
                     DispatchQueue.main.async {
                         
                         // Just to make the status answer more visible and profesional ;)
                         print(result.status!)
                         self.label1.text = "Server Status: \(result.status!). Data at your location:"
                         let range = (self.label1.self.text! as NSString).range(of: result.status!)
                         let attributedString = NSMutableAttributedString(string:self.label1.self.text!)
                         attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green , range: range)
                         self.label1.attributedText = attributedString
                         self.label1.sizeToFit()
                         
                         print(result.sunrise!)
                        self.label2.text = "Sunrise at: \(self.convertToUTC(dateToConvert: result.sunrise!))"
                         self.label2.sizeToFit()
                         
                         print(result.sunset!)
                        self.label3.text = "Sunset at: \(self.convertToUTC(dateToConvert: result.sunset!))"
                         self.label3.sizeToFit()
                         
                         print(result.solar_noon!)
                        self.label4.text = "Solar noon at: \(self.convertToUTC(dateToConvert: result.solar_noon!))"
                         self.label4.sizeToFit()
                         
                         print(result.day_length!)
                         self.label5.text = "Day length is: \(result.day_length!)"
                         self.label5.sizeToFit()
                         
                         print(result.civil_twilight_begin!)
                        self.label6.text = "Civil twilight begins at: \(self.convertToUTC(dateToConvert: result.civil_twilight_begin!))"
                         self.label6.sizeToFit()
                         
                         print(result.civil_twilight_end!)
                        self.label7.text = "Civil twilight ends at: \(self.convertToUTC(dateToConvert: result.civil_twilight_end!))"
                         self.label7.sizeToFit()
                         
                         print(result.nautical_twilight_begin!)
                        self.label8.text = "Nautical twilight begins at: \(self.convertToUTC(dateToConvert: result.nautical_twilight_begin!))"
                         self.label8.sizeToFit()
                         
                         print(result.nautical_twilight_end!)
                        self.label9.text = "Nautical twilight ends at: \(self.convertToUTC(dateToConvert: result.nautical_twilight_end!))"
                         self.label9.sizeToFit()
                         
                         print(result.astronomical_twilight_begin!)
                        self.label10.text = "Astronomical twilight begins at: \(self.convertToUTC(dateToConvert: result.astronomical_twilight_begin!))"
                         self.label10.sizeToFit()
                         
                         print(result.astronomical_twilight_end!)
                        self.label11.text = "Astronomical twilight ends at: \(self.convertToUTC(dateToConvert: result.astronomical_twilight_end!))"
                         self.label11.sizeToFit()
                     }
                 } catch let jsonErr {
                     print("Error serializing json:", jsonErr)
                 }
             }.resume()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let placeClient = GMSPlacesClient()
        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error: Error?) -> Void in
            
            self.resultsArray.removeAll()
            if results == nil {
                return
            }
            
            for result in results! {
                if let result = result as GMSAutocompletePrediction? {
                    self.resultsArray.append(result.attributedFullText.string)
                }
                self.searchResultController.reloadDataWithArray(self.resultsArray)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
    }
    
    //-------------Convertation the time
    func convertToUTC(dateToConvert:String) -> String {
     let formatter = DateFormatter()
     formatter.dateFormat = "h:mm:ss a"
     let convertedDate = formatter.date(from: dateToConvert)
     formatter.timeZone = TimeZone(identifier: "UTC")
     return formatter.string(from: convertedDate!)
    }
    
    //-----------------------------------
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        label1.center = CGPoint(x: 160, y: 285)
        label1.textAlignment = .center
        label1.text = ""
        label1.font = label1.font.withSize(14)
        label1.center.x = self.view.center.x-50
        label1.center.y = self.view.center.y-125
        self.view.addSubview(label1)
        
        label2.center = CGPoint(x: 160, y: 285)
        label2.textAlignment = .center
        label2.text = ""
        label2.font = label2.font.withSize(14)
        label2.center.x = self.view.center.x-50
        label2.center.y = self.view.center.y-100
        self.view.addSubview(label2)
        
        label3.center = CGPoint(x: 160, y: 285)
        label3.textAlignment = .center
        label3.text = ""
        label3.font = label3.font.withSize(14)
        label3.center.x = self.view.center.x-50
        label3.center.y = self.view.center.y-75
        self.view.addSubview(label3)
        
        label4.center = CGPoint(x: 160, y: 285)
        label4.textAlignment = .center
        label4.text = ""
        label4.font = label4.font.withSize(14)
        label4.center.x = self.view.center.x-50
        label4.center.y = self.view.center.y-50
        self.view.addSubview(label4)
        
        label5.center = CGPoint(x: 160, y: 285)
        label5.textAlignment = .center
        label5.text = ""
        label5.font = label5.font.withSize(14)
        label5.center.x = self.view.center.x-50
        label5.center.y = self.view.center.y-25
        self.view.addSubview(label5)
        
        label6.center = CGPoint(x: 160, y: 285)
        label6.textAlignment = .center
        label6.text = ""
        label6.font = label6.font.withSize(14)
        label6.center.x = self.view.center.x-50
        label6.center.y = self.view.center.y
        self.view.addSubview(label6)
        
        label7.center = CGPoint(x: 160, y: 285)
        label7.textAlignment = .center
        label7.text = ""
        label7.font = label7.font.withSize(14)
        label7.center.x = self.view.center.x-50
        label7.center.y = self.view.center.y+25
        self.view.addSubview(label7)
        
        label8.center = CGPoint(x: 160, y: 285)
        label8.textAlignment = .center
        label8.text = ""
        label8.font = label8.font.withSize(14)
        label8.center.x = self.view.center.x-50
        label8.center.y = self.view.center.y+50
        self.view.addSubview(label8)
        
        label9.center = CGPoint(x: 160, y: 285)
        label9.textAlignment = .center
        label9.text = ""
        label9.font = label9.font.withSize(14)
        label9.center.x = self.view.center.x-50
        label9.center.y = self.view.center.y+75
        self.view.addSubview(label9)
        
        label10.center = CGPoint(x: 160, y: 285)
        label10.textAlignment = .center
        label10.text = ""
        label10.font = label10.font.withSize(14)
        label10.center.x = self.view.center.x-50
        label10.center.y = self.view.center.y+100
        self.view.addSubview(label10)
        
        label11.center = CGPoint(x: 160, y: 285)
        label11.textAlignment = .center
        label11.text = ""
        label11.font = label11.font.withSize(14)
        label11.center.x = self.view.center.x-50
        label11.center.y = self.view.center.y+125
        self.view.addSubview(label11)
        
        guard let url = URL(string: jsonURLString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(Result.self, from: data)
                DispatchQueue.main.async {
                    
                    // Just to make the status answer more visible and profesional ;)
                    print(result.status!)
                    self.label1.text = "Server Status: \(result.status!). Data at your location:"
                    let range = (self.label1.self.text! as NSString).range(of: result.status!)
                    let attributedString = NSMutableAttributedString(string:self.label1.self.text!)
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green , range: range)
                    self.label1.attributedText = attributedString
                    self.label1.sizeToFit()
                    
                    print(result.sunrise!)
                    self.label2.text = "Sunrise at: \(self.convertToUTC(dateToConvert: result.sunrise!))"
                    self.label2.sizeToFit()
                    
                    print(result.sunset!)
                    self.label3.text = "Sunset at: \(self.convertToUTC(dateToConvert: result.sunset!))"
                    self.label3.sizeToFit()
                    
                    print(result.solar_noon!)
                    self.label4.text = "Solar noon at: \(self.convertToUTC(dateToConvert: result.solar_noon!))"
                    self.label4.sizeToFit()
                    
                    print(result.day_length!)
                    self.label5.text = "Day length is: \(result.day_length!)"
                    self.label5.sizeToFit()
                    
                    print(result.civil_twilight_begin!)
                    self.label6.text = "Civil twilight begins at: \(self.convertToUTC(dateToConvert: result.civil_twilight_begin!))"
                    self.label6.sizeToFit()
                    
                    print(result.civil_twilight_end!)
                    self.label7.text = "Civil twilight ends at: \(self.convertToUTC(dateToConvert: result.civil_twilight_end!))"
                    self.label7.sizeToFit()
                    
                    print(result.nautical_twilight_begin!)
                    self.label8.text = "Nautical twilight begins at: \(self.convertToUTC(dateToConvert: result.nautical_twilight_begin!))"
                    self.label8.sizeToFit()
                    
                    print(result.nautical_twilight_end!)
                    self.label9.text = "Nautical twilight ends at: \(self.convertToUTC(dateToConvert: result.nautical_twilight_end!))"
                    self.label9.sizeToFit()
                    
                    print(result.astronomical_twilight_begin!)
                    self.label10.text = "Astronomical twilight begins at: \(self.convertToUTC(dateToConvert: result.astronomical_twilight_begin!))"
                    self.label10.sizeToFit()
                    
                    print(result.astronomical_twilight_end!)
                    self.label11.text = "Astronomical twilight ends at: \(self.convertToUTC(dateToConvert: result.astronomical_twilight_end!))"
                    self.label11.sizeToFit()
                }
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
        }.resume()
    }


}


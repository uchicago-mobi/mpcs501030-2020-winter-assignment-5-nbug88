//
//  DataManager.swift
//  map5anaru
//
//  Created by Akhil Naru on 2/14/20.
//  Copyright © 2020 Akhil Naru. All rights reserved.
//

import Foundation
import MapKit

public class DataManager {
    
    // MARK: - Singleton Stuff
    public static let sharedInstance = DataManager()
    
    //This prevents others from using the default '()' initializer
    fileprivate init() {}
    
    //The list of favourites as dictionary
    var listOfLocations = [String: MyPlaces]()
    var listOfFav = [String?: Place]()
    
    
    // Your code (these are just example functions, implement what you need)
    func loadAnnotationFromPlist(_ map: MKMapView) {
        let urlPath = Bundle.main.url(forResource: "Data", withExtension: "plist")
        var locations: MyLocations?
        do {
            let data = try Data(contentsOf: urlPath!)
            let decoder = PropertyListDecoder()
            locations = try decoder.decode(MyLocations.self, from: data)
        } catch {
            // Handle error
            print("There is an error with decoding the plist file")
            print(error)
        }
        
        //let locations = DataManager.sharedInstance.loadAnnotationFromPlist()
        
        // Adding places to the mao
        for items in locations!.places {
            self.listOfLocations[items.name] = items
            let coordinates = CLLocationCoordinate2D(latitude: items.lat, longitude: items.long)
            let annotation = Place(name: items.name,
                                   desc: items.description)
            annotation.coordinate = coordinates
            annotation.title = items.name
            map.addAnnotation(annotation)
        }
        
        
    }
    
    func saveFavorites(_ newPlace: Place) {
        // Add to the dictionary of favourites
        listOfFav[newPlace.name!] = newPlace
        newPlace.favorite = true
        print(listOfFav)
    }
    func deleteFavorite(_ newPlace: Place) {
        // Remove from the dictionary of favourites
        listOfFav[newPlace.name!] = nil
        newPlace.favorite = false
        print(listOfFav)
    }
    func listFavorites() -> Array<String?> {
        // List the dictionary of favourites
        var list = [String?]()
        for item in listOfFav {
            list.append(item.value.name)
        }
        return list
    }
    
}

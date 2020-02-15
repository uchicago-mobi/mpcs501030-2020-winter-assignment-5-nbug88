//
//  MapAnnotation.swift
//  map5anaru
//
//  Created by Akhil Naru on 2/13/20.
//  Copyright © 2020 Akhil Naru. All rights reserved.
//

import Foundation
import MapKit

class Place: MKPointAnnotation {
    // Name of the point of interest
    var name: String?
    // Description of the point of interest
    var longDescription: String?
    //Title and Coordinate are existing properties.
    var favorite = false
    
    init(name: String?, desc: String?) {
        self.name = name
        self.longDescription = desc
    }
}

class PlaceMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = "Place"
            displayPriority = .defaultLow
            //markerTintColor = .systemRed
            glyphImage = UIImage(systemName: "pin.fill")
            canShowCallout = true
        }
    }
}

struct MyLocations: Codable, Hashable {
    var places: [MyPlaces]
    var region: [Double]
}

struct MyPlaces: Codable, Hashable {
    var name: String
    var description: String
    var lat: Double
    var long: Double
    var type: Int
}




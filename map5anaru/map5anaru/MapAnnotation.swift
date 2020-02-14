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
    
    init(name: String, desc: String) {
        self.name = name
        self.longDescription = desc
    }
}
//
//class AnnotationDetail: NSObject, MKAnnotation {
//    let title: String?
//    let subtitle: String?
//    let coordinate: CLLocationCoordinate2D
//    
//    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
//        self.title = title
//        self.subtitle = subtitle
//        self.coordinate = coordinate
//        super.init()
//    }
//}

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

//struct MyRegions: Codable, Hashable {
//    var loca: Double
//    var locb: Double
//    var locc: Double
//    var locd: Double
//}




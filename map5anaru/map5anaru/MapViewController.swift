//
//  MapViewController.swift
//  map5anaru
//
//  Created by Akhil Naru on 2/13/20.
//  Copyright © 2020 Akhil Naru. All rights reserved.
//
// location of plist file - https://www.hackingwithswift.com/example-code/system/how-to-find-the-path-to-a-file-in-your-bundle
// Using custom MyPintAnnotation https://forums.developer.apple.com/thread/70205

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet var titlePin: UILabel!
    @IBOutlet var pinDetail: UILabel!
    
    @IBOutlet var mapView: MKMapView! {
        didSet { mapView.delegate = self }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        
        // Setting up the starting View of the MAP
        
        let miles: Double = 500 * 1600/16
        // Set a center point
        let zoomLocation = CLLocationCoordinate2DMake(41.7897, -87.5997)
        // Creat the region we want to see
        let viewRegion = MKCoordinateRegion.init(center: zoomLocation,
                                                 latitudinalMeters: miles, longitudinalMeters: miles)
        // Set the initial region on the map
        mapView.setRegion(viewRegion, animated: true)
        
        // Adding points to the map
//        let coordinates = CLLocationCoordinate2DMake(41.7897, -87.5997)
//        let annotation = AnnotationDetail(title: "The University of Chicago",
//        subtitle: "2nd Happiest Place on Earth", coordinate: coordinates)
//        mapView.addAnnotation(annotation)
        
    
        
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
        
        
        /// Adding places to the mao
        for items in locations!.places {
            let coordinates = CLLocationCoordinate2D(latitude: items.lat, longitude: items.long)
            let annotation = Place(name: items.name,
                                    desc: items.description)
                annotation.coordinate = coordinates
                annotation.title = items.name
                mapView.addAnnotation(annotation)
        }
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController: MKMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("sdf")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? Place {
            let identifier = "CustomPin"
            // Create a new view
            var view: PlaceMarkerView
            // Deque an annotation view or create a new one
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? PlaceMarkerView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = PlaceMarkerView(annotation: annotation, reuseIdentifier: identifier)
            }
            
            return view
        }
        return nil
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        if let annotation = annotation as? AnnotationDetail {
//            let identifier = "CustomPin"
//            // Create a new view
//            var view: PlaceMarkerView
//            // Deque an annotation view or create a new one
//            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? PlaceMarkerView {
//                dequeuedView.annotation = annotation
//                view = dequeuedView
//            } else {
//                view = PlaceMarkerView(annotation: annotation, reuseIdentifier: identifier)
//            }
//
//            return view
//        }
//        return nil
//    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let customAnnotation = view.annotation as? Place {
            self.pinDetail.lineBreakMode = NSLineBreakMode.byWordWrapping
            self.pinDetail.numberOfLines = 0

            self.pinDetail.text = customAnnotation.longDescription!
            self.titlePin.text = customAnnotation.name!
        }
    }
    
}

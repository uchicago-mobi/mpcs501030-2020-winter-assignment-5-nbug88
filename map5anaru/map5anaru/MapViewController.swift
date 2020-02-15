//
//  MapViewController.swift
//  map5anaru
//
//  Created by Akhil Naru on 2/13/20.
//  Copyright © 2020 Akhil Naru. All rights reserved.
//
// location of plist file - https://www.hackingwithswift.com/example-code/system/how-to-find-the-path-to-a-file-in-your-bundle
// Using custom MyPintAnnotation https://forums.developer.apple.com/thread/70205
// Tulip's help and Office Hours for references

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var titlePin: UILabel!
    @IBOutlet var pinDetail: UILabel!
    @IBOutlet var starButton: UIButton!
    // To keep track of the current selected place
    var selectedPlace = Place(name: nil,desc: nil)
    
    @IBOutlet var mapView: MKMapView! {
        didSet { mapView.delegate = self }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the button to empty star to start
        starButton.setImage(UIImage(systemName: "star"), for: .normal)
        starButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        
        // Setting up the starting View of the MAP
        let miles: Double = 20000
        let zoomLocation = CLLocationCoordinate2DMake(41.9, -87.655697)
        let viewRegion = MKCoordinateRegion.init(center: zoomLocation,
                                                 latitudinalMeters: miles, longitudinalMeters: miles)
        mapView.setRegion(viewRegion, animated: true)
        
        DataManager.sharedInstance.loadAnnotationFromPlist(mapView)
    }

    @objc func buttonTapped(_ sender: UIButton) {
        
        if starButton.currentImage == UIImage(systemName: "star")
        { print("emter 1")
            DataManager.sharedInstance.saveFavorites(selectedPlace)
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            // save fourtites using the DataManager.
            // Change the state of the button state.
        }
        
        else if starButton.currentImage == UIImage(systemName: "star.fill")
        { print("emter 2")
            // delete from fourtites using the DataManager.
            DataManager.sharedInstance.deleteFavorite(selectedPlace)
            // Change the state of the button state.
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TableViewController {
            destination.delegate = self
        }
    }
    
    @IBAction func favorites(_ sender: Any) {
        print("akhil")

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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let customAnnotation = view.annotation as? Place {
            self.pinDetail.lineBreakMode = NSLineBreakMode.byWordWrapping
            self.pinDetail.numberOfLines = 0

            self.pinDetail.text = customAnnotation.longDescription!
            self.titlePin.text = customAnnotation.name!
            
            selectedPlace = customAnnotation
            
            if selectedPlace.favorite == true  {
                //Update the button to filled star if the selected annotation is favorite
                starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                starButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    
}

extension MapViewController: FavDetailDelegate {
    func MoveToPlace(data: String) {
        
        let list = DataManager.sharedInstance.listOfFav
        
        for item in list {
            print(item)
            if item.key! == data {
                selectedPlace = item.value
                starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }
        }

        //Center on the selected favorite and update the labels
        let miles: Double = 2500
        let zoomLocation = selectedPlace.coordinate
        let viewRegion = MKCoordinateRegion(center: zoomLocation, latitudinalMeters: miles, longitudinalMeters: miles)
        mapView.setRegion(viewRegion, animated: true)
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        self.pinDetail.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.pinDetail.numberOfLines = 0
        self.pinDetail.text = selectedPlace.longDescription!
        self.titlePin.text = selectedPlace.name!
        
    }
}

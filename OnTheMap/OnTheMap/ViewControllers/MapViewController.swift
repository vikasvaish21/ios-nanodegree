//
//  MapViewController.swift
//  OnTheMap
//
//  Created by vikas on 18/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import MapKit
import CoreLocation
import UIKit

class MapViewController:UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadStudentLocation()
        }
    
    @IBAction func refreshButton(_ sender: Any) {
        loadStudentLocation()
    }
    
    @IBAction func logOut(_ sender: Any) {
        NetworkManager.logout{(errorMessage) in
            if let error = errorMessage{
                DataTaskController.showSimpleAlert(viewController: self, title: "Failed to Logout", message: error)
            }
            else{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    func loadStudentLocation(){
        NetworkManager.getUniqueStudentLocation(type: .allLocations){
            (locations,errorMessage) in
            if let error = errorMessage{
                DataTaskController.showSimpleAlert(viewController: self, title: "failed to Get Location", message: error)
            }
            else{
                DispatchQueue.main.async {
                    self.updateMap()
                }
            }
        }
    }
    func updateMap(){
        mapView.removeAnnotations(mapView.annotations)
        if let studentLocations = Parse.studentLocations{
            for location in studentLocations{
                let annotation = MKPointAnnotation()
                if let latitude = location.latitude,let longitude = location.longitude{
                    annotation.coordinate = CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
                    annotation.title = location.mapString
                    annotation.subtitle = location.mediaURL
                    mapView.addAnnotation(annotation)
                }
            }
        }
        
    }
}
extension MapViewController:MKMapViewDelegate{
    func mapView(_ mapView:MKMapView,viewFor annotation:MKAnnotation)-> MKAnnotationView?{
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else{
            pinView!.annotation = annotation
        }
        return pinView
    }
    func mapView(_ mapView:MKMapView,annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl){
        if control == view.rightCalloutAccessoryView{
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!{
                app.open(URL(string: toOpen)!,options: [:],completionHandler:nil)
            }
        }
    }
}

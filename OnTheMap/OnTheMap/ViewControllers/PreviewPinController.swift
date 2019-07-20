//
//  PreviewPinController.swift
//  OnTheMap
//
//  Created by vikas on 19/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class PreviewPinController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var coordinate: CLLocationCoordinate2D!
    var mediaURL: String!
    var mapString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let firstName = Udacity.user?.firstName
        let lastName = Udacity.user?.lastName
        mapString = "\(firstName ?? "") \(lastName ?? "")"
        if mapString == " " {
            mapString = Udacity.user?.nickname ?? "-NONE-"
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = mapString
        annotation.subtitle = mediaURL
        mapView.addAnnotation(annotation)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: false)
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        NetworkManager.setStudentLocation(mapString: mapString, mediaURL: mediaURL, latitude: Float(coordinate.latitude), longitude: Float(coordinate.longitude)) { (errorMessage) in
            if let error = errorMessage {
                DataTaskController.showSimpleAlert(viewController: self, title: "Failed to submit Pin", message: error)
            }
            else {
                self.navigationController?.viewControllers[0].dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
}

extension PreviewPinController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
}

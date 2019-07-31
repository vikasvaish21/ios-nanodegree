//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by vikas on 29/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData
class MapViewController: UIViewController{
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deleteLabel: UILabel!
    
    var resultController:NSFetchedResultsController<Pin>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        deleteLabel.isHidden = true
        navigationItem.rightBarButtonItem = editButtonItem
        addGestureToMap()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchResultController()
        setMapRegion()
        setupMarkers()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resultController = nil
    }
    
    override func setEditing(_ editing:Bool,animated:Bool){
        super.setEditing(editing, animated: animated)
        deleteLabel.isHidden = !editing
    }
    
    
    fileprivate func setupFetchResultController() {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchRequest.sortDescriptors = []
        resultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:
            DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try resultController.performFetch()
        }
        catch{
            fatalError("The Fetch Couldn,t be performed: \(error.localizedDescription)")
        }
    }
    
    fileprivate func  setupMarkers(){
        let pins = resultController.fetchedObjects
        mapView.removeAnnotations(mapView.annotations)
        
        
        for pin  in pins!{
            addMarkerToMap(coordinate: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude))
                
            }
        }
    
    fileprivate func setMapRegion(){
        if let mapRegion = UserDefaults.standard.dictionary(forKey: "mapRegion"){
            let center = CLLocationCoordinate2DMake(mapRegion["lat"] as! Double, mapRegion["long"] as! Double)
            let span = MKCoordinateSpan(latitudeDelta: mapRegion["latDelta"] as! Double, longitudeDelta: mapRegion["longDelta"] as! Double)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let vc = segue.destination as? DetailViewController{
            let pin = sender as! Pin
            vc.pinTapped = pin
        }
    }
}

extension MapViewController{
    private func addGestureToMap(){
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addMarker(gesture:)))
        gestureRecognizer.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    
    @objc func addMarker(gesture: UILongPressGestureRecognizer){
        if gesture.state == .began{
            let pinLocation = gesture.location(in: mapView)
            let pinCoordinate = mapView.convert(pinLocation, toCoordinateFrom: mapView)
            addMarkerToMap(coordinate: pinCoordinate)
            addPin(coordinate:pinCoordinate)
            
        }
    }
    
    func addMarkerToMap(coordinate:CLLocationCoordinate2D){
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
    func addPin(coordinate:CLLocationCoordinate2D){
        let PinToAdd = Pin(context: DataController.shared.viewContext)
        PinToAdd.latitude = coordinate.latitude
        PinToAdd.longitude = coordinate.longitude
        saveViewContext()
    }
    
    func getPin(latitude: Double,longitude:Double) -> Pin? {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let predicate = NSPredicate(format: "latitude ==  %lf AND longitude == %lf", latitude, longitude)
        fetchRequest.predicate = predicate
        guard let pin = (try? DataController.shared.viewContext.fetch(fetchRequest))!.first else{
            return nil
        }
        return pin
    }
    
    func saveViewContext(){
        try? DataController.shared.viewContext.save()
    }
}
extension MapViewController:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // make reusable pinView
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView?.animatesDrop = true
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let pin = getPin(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!) else {
            self.showAlertMessage(message: "Pin not found in db")
            return
        }
        
        if isEditing {
            DataController.shared.viewContext.delete(pin)
            saveViewContext()
            mapView.removeAnnotation(view.annotation!)
            
        } else {
            performSegue(withIdentifier: "detailView", sender: pin)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let defaults = UserDefaults.standard
        let locationData = ["lat":mapView.centerCoordinate.latitude
            , "long":mapView.centerCoordinate.longitude
            , "latDelta":mapView.region.span.latitudeDelta
            , "longDelta":mapView.region.span.longitudeDelta]
        defaults.set(locationData, forKey: "mapRegion")
    }
}

//
//  DetailViewController.swift
//  VirtualTourist
//
//  Created by vikas on 29/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import MapKit
class DetailViewController: UIViewController{
    private var blockOperation = BlockOperation()
    
    var pinTapped:Pin!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var noImageLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    
    var resultController:NSFetchedResultsController<Photo>!
    
    var itemChanges = [NSFetchedResultsChangeType:IndexPath]()
    var sectionChanges = [NSFetchedResultsChangeType:IndexSet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2DMake(pinTapped.latitude, pinTapped.longitude)
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: pin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)),animated: true)
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.title = "Photo Album"
        editLabel.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultController()
        if(resultController.fetchedObjects?.count)! < 1 {
            reloadImageCollection(nil)
        }
        collectionView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resultController = nil
    }
    
    override func setEditing(_ editing:Bool,animated:Bool ){
        super.setEditing(editing, animated: animated)
        editLabel.isHidden = !editing
        reloadButton.isHidden = editing
    }
    
    fileprivate func setupFetchedResultController(){
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin ==  %@", pinTapped)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = []
        resultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        resultController.delegate = self
        do{
            try resultController.performFetch()
        }
        catch{
            fatalError("The fetch request could not be performed: \(error.localizedDescription)")
            
        }
    }
    @IBAction func reloadImageCollection(_ sender: Any?) {
        
        deletePhotos()
        showNoImageLabel(show: false)
        reloadButtonEnabled(isEnabled: false)
        
        let request = FlickerAPI.shared.createRequest(pin: pinTapped)
        FlickerAPI.shared.getRequest(request: request){
            (result,error) in
            guard error == nil else{
                self.showAlertMessage(message:error!)
                self.showNoImageLabel(show:true)
                self.reloadButtonEnabled(isEnabled:true)
                return
            }
            guard result!.count > 0 else{
                self.showNoImageLabel(show:true)
                self.reloadButtonEnabled(isEnabled:true)
                return
            }
            self.addPhotos(photos:result!)
            self.reloadButtonEnabled(isEnabled:true)
            }
    }
    fileprivate func addPhotos(photos:NSArray){
        for _ in 1...15{
            let randomPhotoIndex = Int(arc4random_uniform(UInt32(photos.count)))
            let photo = photos[randomPhotoIndex] as!  [String:AnyObject]
            guard let imageUrl = photo[Constants.FlickrResponseKeys.ImageUrl] as? String else {
                return
            }
            let photoToAdd = Photo(context: DataController.shared.viewContext)
            photoToAdd.pin = pinTapped
            photoToAdd.imageUrl = imageUrl
            saveViewContext()
        }
    }
    
    fileprivate func deletePhotos(){
        for photo in (resultController!.fetchedObjects)! {
            DataController.shared.viewContext.delete(photo)
            saveViewContext()
           
        }
    }

    func saveViewContext(){
        try? DataController.shared.viewContext.save()
    }
    
    fileprivate func showNoImageLabel(show:Bool){
        DispatchQueue.main.async {
            self.noImageLabel.isHidden = !show
        }
    }

    fileprivate func reloadButtonEnabled(isEnabled:Bool){
        DispatchQueue.main.async {
            self.reloadButton.isEnabled = isEnabled
        }
    }
    
//    deinit {
//        // Cancel all block operations when VC deallocates
//        for operation: BlockOperation in blockOperation {
//            operation.cancel()
//        }
//
//        blockOperations.removeAll(keepingCapacity: false)
//    }
}
extension DetailViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return resultController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return resultController.sections?[section].numberOfObjects ?? 0
        
    }
    func  collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = resultController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! PhotoCell
        cell.imageView.image = nil
        cell.activityIndicator.startAnimating()
        
        if photo.image == nil{
            FlickerAPI.shared.downloadImage(imageUrl: photo.imageUrl!){
                (image,error) in
                guard error == nil else{
                    self.showAlertMessage(message: error!)
                    return
                }
                DispatchQueue.main.async {
                    photo.image = image
                    self.saveViewContext()
                    cell.activityIndicator.stopAnimating()
                }
            }
        }else{
            cell.imageView.image = UIImage(data: photo.image!)
            cell.activityIndicator.stopAnimating()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if isEditing{
            let photo = resultController.object(at: indexPath)
            DataController.shared.viewContext.delete(photo)
            saveViewContext()
        }
    }
}
extension DetailViewController:NSFetchedResultsControllerDelegate{
    
   
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //keep track of all items related changes in self.itemChanges dictionary so that we can apply them in batch
        switch type {
        case .insert:
            itemChanges[type] = newIndexPath
            break
        case .delete:
            itemChanges[type] = indexPath
            break
        case .update:
            itemChanges[type] = indexPath
        default:
            collectionView.reloadData()
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        //keep track of section related changes so that we can apply them in batch
        let indexSet = IndexSet(integer: sectionIndex)
        sectionChanges[type] = indexSet
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //BeginUpdates: new changes are about to begin so discard outdated changes that we have already applied
        itemChanges.removeAll()
        sectionChanges.removeAll()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //EndUpdates: Now all changes are triggered, let's apply all changes in batch
        collectionView.performBatchUpdates({
            //apply section related changes
            for (type, indexSet) in sectionChanges {
                applySectionChange(type, indexSet)
            }
            
            //apply items changes
            for (type, indexPath) in itemChanges {
                applyItemChange(type, indexPath)
            }
        }, completion: nil)
        
    }
    
    private func applyItemChange(_ type: NSFetchedResultsChangeType, _ indexPath: IndexPath) {
        switch type {
        case .insert:
            self.collectionView.insertItems(at: [indexPath])
            break
        case .delete:
            self.collectionView.deleteItems(at: [indexPath])
            break
        case .update:
            self.collectionView.reloadItems(at: [indexPath])
        default:
            collectionView.reloadData()
            break
        }
    }
    
    private func applySectionChange(_ type: NSFetchedResultsChangeType, _ indexSet: IndexSet) {
        switch type {
        case .insert:
            self.collectionView.insertSections(indexSet)
        case .delete:
            self.collectionView.deleteSections(indexSet)
        default:
            self.collectionView.reloadData()
        }
    }
}

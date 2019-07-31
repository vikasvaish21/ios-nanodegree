//
//  ViewController.swift
//  VirtualTourist
//
//  Created by vikas on 28/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistenceContainer:NSPersistentContainer
    
    static let shared = DataController(modelName: "VirtualTourist")
    
    var viewContext:NSManagedObjectContext{
        return persistenceContainer.viewContext
    }
    
    var backgroundContext:NSManagedObjectContext!

    init(modelName:String){
        persistenceContainer = NSPersistentContainer(name: modelName)
    }
    
    func configureContexts(){
        backgroundContext = persistenceContainer.newBackgroundContext()
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completionHandler: (() -> Void)? = nil){
        persistenceContainer.loadPersistentStores() {
            (storeDescription,error) in
            guard error == nil else{
                fatalError(error!.localizedDescription)
            }
            self.autosaveViewContext()
            self.configureContexts()
        }
    }
}
extension DataController{
    func autosaveViewContext(interval:TimeInterval = 30){
        guard interval > 0 else{
            return
        }
        
        if viewContext.hasChanges{
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autosaveViewContext()
        }
    }
}


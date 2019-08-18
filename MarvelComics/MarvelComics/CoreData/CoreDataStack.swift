//
//  CoreDataStack.swift
//  MarvelComics
//
//  Created by vikas on 12/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import CoreData
class CoreDataStack{
    static let sharedInstance = CoreDataStack(modelName: "Marvel")
    
    private let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    var backgroundContext: NSManagedObjectContext!
    
    private init(modelName:String){
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    private func configureContexts(){
        backgroundContext = persistentContainer.newBackgroundContext()
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    func load(completion:(() -> Void)? = nil){
        persistentContainer.loadPersistentStores{(storeDescription,error)
            in guard error == nil else{
                fatalError(error!.localizedDescription) }
            self.configureContexts()
            self.autoSaveContext()
            completion?()
            }
        }
    
    
    func autoSaveContext(interval:TimeInterval = 30){
        guard interval > 0 else{
            print("interval must be positive"); return }
            if viewContext.hasChanges{
                try? viewContext.save() }
            if backgroundContext.hasChanges{
                try? backgroundContext.save() }
            DispatchQueue.main.asyncAfter(deadline: .now() + interval){
                self.autoSaveContext(interval: interval)
            }
        }
    
    func saveViewContext(errorHandler: ((_ error:Error?) -> Void)? = nil){
        viewContext.perform {
            if self.viewContext.hasChanges{
                do{
                    try self.viewContext.save()
                    errorHandler?(nil)
                }
                catch{
                    errorHandler?(error)
                    print(error.localizedDescription)
                }
            }
        }
    }

    func saveBackgroundContext(errorHandler:((_ error:Error?) -> Void)? = nil){
        backgroundContext.perform {
            if self.backgroundContext.hasChanges{
                do{
                    try self.backgroundContext.save()
                    errorHandler?(nil)
                }
                catch{
                    errorHandler?(error)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func save(errorHanler: ((_ error:Error?) -> Void)? = nil){
        self.saveViewContext(errorHandler: errorHanler)
        self.saveBackgroundContext(errorHandler: errorHanler)
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void){
        backgroundContext.perform{
                block(self.backgroundContext)
        }
    }
    
    func performViewTask(_ block: @escaping (NSManagedObjectContext) -> Void){
        viewContext.perform {
            DispatchQueue.main.async {
                block(self.viewContext)
            }
        }
    }
    
    
    
}

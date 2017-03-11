//
//  NSPersistentStore+Migrate.swift
//  chaatz
//
//  Created by Mingloan Chan on 12/30/16.
//  Copyright © 2016 Chaatz. All rights reserved.
//

import CoreData

extension NSPersistentStore {
    class func migratePersistentStore(from originalURL: URL, to destinationURL: URL, with model: NSManagedObjectModel, options: [String: Any]) {
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        do {
            try psc.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: originalURL,
                options: options)
        } catch {
            fatalError("Failed to reference old store: \(error)")
        }
        
        guard let oldStore = psc.persistentStore(for: originalURL) else {
            fatalError("Failed to reference old store")
        }
        
        do {
            try psc.migratePersistentStore(oldStore, to: destinationURL, options: options, withType: NSSQLiteStoreType)
            debug_print("migration completed")
        }
        catch let error {
            fatalError("Failed to migrate store: \(error)")
        }
    }
}

//
//  DatabaseHandler.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import CoreData

var savedObjects1: [NSManagedObject]! = []
var error2: NSError?
class DatabaseHandler: NSObject {
    static let sharedinstance = DatabaseHandler()
      func managedObjectContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
      func countForExistingDataForTable(tableName: String, andPredicate predicate: NSPredicate) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        let context = DatabaseHandler.sharedinstance.managedObjectContext()
        let Entity = NSEntityDescription.entity(forEntityName: tableName, in: context)
        fetchRequest.predicate = predicate
        fetchRequest.entity = Entity
        
        let count:Int
        
        do {
            count = try context.count(for: fetchRequest)
            print("Saved!")
        } catch let error as NSError {
            count = 0
            print("Error: \(error)")
        }
            //context.countForFetchRequest(fetchRequest, error: nil)
        
        return (count > 0) ? false: true
    }
    
      func countForDataForTable(tableName: String) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        let context = DatabaseHandler.sharedinstance.managedObjectContext()
        let Entity = NSEntityDescription.entity(forEntityName: tableName, in: context)
        fetchRequest.entity = Entity
        
        var count:Int
        
        do {
            count = try context.count(for: fetchRequest)
            print("Saved!")
        } catch let error as NSError {
            count = 0
            print("Error: \(error)")
        }
        
        return (count > 0) ? true: false
    }
    
      func insertDataForTable(tableName: String, dictValues data:NSDictionary) {
        
        let context = DatabaseHandler.sharedinstance.managedObjectContext()
        let entity =  NSEntityDescription.entity(forEntityName: tableName,
                                                 in:context)
        let obj = NSEntityDescription.insertNewObject(forEntityName: tableName, into: context)
        
        obj.safeSetValuesForKeys(with: data as! [String : AnyObject])
        do {
            try context.save()
        } catch _ {
            
        }
    }
    
    
      func truncateDataForTable(tableName: String) {
        
        let context = DatabaseHandler.sharedinstance.managedObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: tableName, in: context)
        fetchRequest.includesPropertyValues = false
        
        let error:NSError?
        if let results = try! context.fetch(fetchRequest) as? [NSManagedObject] {
            for result in results {
                context.delete(result)
            }
            
           
            do {
                try! context.save()
                // do something after save
                
            } catch let error1 as NSError {
                error = error1
                if let error = error {
                    print(error.userInfo)
                }
            }
            
        }
    }

    
    
      func fetchDataFromTable(tableName: String){
    
    let managedContext = managedObjectContext()
    
    //2
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
    
    fetchRequest.entity = NSEntityDescription.entity(forEntityName: tableName, in: managedContext)
    
    fetchRequest.returnsObjectsAsFaults = false
    
    do {
       
        savedObjects1 = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
    }
    catch let error1 as NSError {
        error2 = error1
        savedObjects1 = nil
    } catch {
        // Catch any other errors
    }  }
    
    
    
      func fetchTableAllData(tableName: String) -> NSArray {
        
        let context = DatabaseHandler.sharedinstance.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: tableName, in: context)
        fetchRequest.returnsObjectsAsFaults = false
        
      
        let savedObjects = try! context.fetch(fetchRequest) as? [NSManagedObject]
        return savedObjects! as NSArray
    }
    
      func fetchTableWithPredicate(predicate: NSPredicate, tableName: String, SortDescriptor: String, isAscending:Bool) -> NSArray {
        
        let context = DatabaseHandler.sharedinstance.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: tableName, in: context)
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.predicate  = predicate
        
        if !SortDescriptor.isEmpty {
            
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: SortDescriptor, ascending: isAscending)
            fetchRequest.sortDescriptors = [descriptor]
        }
       
        let savedObjects = try! context.fetch(fetchRequest) as? [NSManagedObject]
        return savedObjects! as NSArray
    }

    
      func updateDataForTable(tableName: String, dictValues data:NSDictionary,andPredicate predicate: NSPredicate) {
        
        let context = DatabaseHandler.sharedinstance.managedObjectContext()
        let batchRequest = NSBatchUpdateRequest(entityName: tableName) // 2
        batchRequest.propertiesToUpdate = data as! [String : AnyObject] // 3
        batchRequest.resultType = .updatedObjectIDsResultType // 4
        batchRequest.predicate = predicate
        let error : NSError?
        
        do {
            let updateResult = try! self.managedObjectContext().execute(batchRequest) as! NSBatchUpdateResult
            
            if let res = updateResult.result {
                
                let objectID = res as! NSArray
                
                for managedObjects in objectID {
                    
                    let object = try! context.existingObject(with: managedObjects as! NSManagedObjectID)
                    context.refresh(object, mergeChanges: false)
                    
                }
                
            } else {
                print("Error during batch update: )")
            }
        } catch let error1 as NSError {
            error = error1
            if let error = error {
                print(error.userInfo)
            }
        }
 
    }
    
        
    
    //Delete
      func deleteColumnById(dataId: String, tableName: String, columnName: String) {
        
        let context = DatabaseHandler.sharedinstance.managedObjectContext()
        
        let fetchObjects = self.fetchParticularForTable(tableName: tableName, ColumnName: columnName, ColumnValue: dataId, SortDescriptor: "") as NSArray
        
        for objectModel in fetchObjects {
            
            context.delete(objectModel as! NSManagedObject)
        }
        
        do {
            try context.save()
        } catch _ {
        }
        
    }
    
      func fetchParticularForTable(tableName: String, ColumnName: String, ColumnValue: String, SortDescriptor: String?) -> NSArray {
        
        let context = DatabaseHandler.sharedinstance.managedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: tableName, in: context)
        fetchRequest.returnsObjectsAsFaults = false
        
        let resultPredicate = NSPredicate(format: "%K == %@", ColumnName, ColumnValue)
        fetchRequest.predicate  = resultPredicate
        
        if (SortDescriptor?.isEmpty) != nil {
            
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: ColumnName, ascending: true)
            fetchRequest.sortDescriptors = [descriptor]
        }
        
        let savedObjects = try! context.fetch(fetchRequest) as? [NSManagedObject]
        return savedObjects! as NSArray
        
    }
    
      func deleteTableWithPredicate(tableName: String, predicate: NSPredicate) {
        
        let context = DatabaseHandler.sharedinstance.managedObjectContext()

        
        let fetchObjects = self.fetchTableWithPredicate(predicate: predicate, tableName: tableName, SortDescriptor: "", isAscending: true)
        
        for objectModel in fetchObjects {
            
            context.delete(objectModel as! NSManagedObject)
        }
        
        do {
            try context.save()
        } catch _ {
        }
    }
      func deleteTable(tableName: String) {
        
        let context = DatabaseHandler.sharedinstance.managedObjectContext()

        
        let fetchObjects = self.fetchTableAllData(tableName: tableName)
        //(predicate, tableName: tableName, SortDescriptor: "", isAscending: true)
        
        for objectModel in fetchObjects {
            
            context.delete(objectModel as! NSManagedObject)
        }
        
        do {
            try context.save()
        } catch _ {
        }
    }

    
}


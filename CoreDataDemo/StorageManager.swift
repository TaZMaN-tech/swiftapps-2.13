//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Тадевос Курдоглян on 18.08.2021.
//

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
    var taskList: [Task] = []
    
    private init() {}
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
 
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            taskList = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func save(_ taskName: String, complition: (IndexPath)->Void) {
        guard let entiyDescription = NSEntityDescription.entity(forEntityName: "Task", in: persistentContainer.viewContext) else {
            return
        }
        guard let task = NSManagedObject(entity: entiyDescription, insertInto: persistentContainer.viewContext) as? Task else { return }
        task.name = taskName
        taskList.append(task)
        
        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        complition(cellIndex)
        //tableView.insertRows(at: [cellIndex], with: .automatic)
        
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

//
//  PersistenceService.swift
//  Yalantis_School
//
//  Created by Valerii on 8/18/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import CoreData

protocol PersistenceStore {
    func fetch() -> [AnswerModel]
    func save(answer: AnswerModel)
    func delete(answer: AnswerModel)
}

class PersistenceService: PersistenceStore {

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Yalantis_School")

        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions.append(description)

        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
        })
        return container
    }()

    private(set) lazy var mainMOC = persistentContainer.viewContext
    private(set) lazy var backgroundMOC = persistentContainer.newBackgroundContext()

    // MARK: - Core Data Saving support

    func saveMainMOC() {
        if mainMOC.hasChanges {
            do {
                try mainMOC.save()
                print("Saved")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func saveBackgroundMOC() {
        if backgroundMOC.hasChanges {
            do {
                try backgroundMOC.save()
                print("Saved")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetch() -> [AnswerModel] {
        var results = [AnswerModel]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedAnswer")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(ManagedAnswer.timestamp), ascending: false)]

        backgroundMOC.performAndWait {
            do {
                let fetchedObjects = try backgroundMOC.fetch(fetchRequest) as? [ManagedAnswer]
                results = fetchedObjects?.map {
                    $0.toAnswerModel(string: $0.answer ?? "", date: $0.timestamp ?? Date())
                } ?? results
            } catch {
                print(error)
            }
        }

        return results
    }

    func save(answer: AnswerModel) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedAnswer")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(ManagedAnswer.timestamp), ascending: false)]
        //fetch from mainMOC
        let main = try! mainMOC.fetch(fetchRequest).first! as? ManagedAnswer
        print("\(main?.answer) first fetch from mainMOC")
        let objectID = main!.objectID

        backgroundMOC.performAndWait {
            let sameAnswer = backgroundMOC.object(with: objectID) as! ManagedAnswer
            sameAnswer.answer = answer.answer
            try! backgroundMOC.save()
            print("\(sameAnswer.answer) saved answer")
        }
        
        let back = try! backgroundMOC.fetch(fetchRequest).first! as? ManagedAnswer
        print("\(back?.answer) answer from backgroundMOC after save")

        try! mainMOC.save()
        // fetch from mainMOC after saved on backgroundMOC
       // let secondMain = try! mainMOC.fetch(fetchRequest).first! as? ManagedAnswer
        print("\(main?.answer) second fetch from mainMOC")
        print("automaticallyMergesChangesFromParent \(mainMOC.automaticallyMergesChangesFromParent)")
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        backgroundMOC.performAndWait {
//            let modelObject = ManagedAnswer(context: backgroundMOC)
//            modelObject.answer = answer.answer.lowercased()
//            modelObject.timestamp = answer.timestamp
//            try! backgroundMOC.save()
//        }
    }

    func delete(answer: AnswerModel) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedAnswer")
        fetchRequest.predicate = NSPredicate(
            format: "answer == %@",
            argumentArray: [answer.answer, answer.timestamp]
        )
        backgroundMOC.performAndWait {
            do {
                let fetchedObjects = try backgroundMOC.fetch(fetchRequest) as? [NSManagedObject]
                guard let fetchedObject = fetchedObjects?.first else { return }
                backgroundMOC.delete(fetchedObject)
                try backgroundMOC.save()
            } catch {
                print(error)
            }
        }
    }
}

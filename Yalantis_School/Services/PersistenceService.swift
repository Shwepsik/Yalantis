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
        })
        return container
    }()

    private(set) lazy var mainMOC = persistentContainer.viewContext
    private(set) lazy var backgroundMOC = persistentContainer.newBackgroundContext()

    init() {
        mainMOC.automaticallyMergesChangesFromParent = true
        mainMOC.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

        backgroundMOC.automaticallyMergesChangesFromParent = true
        backgroundMOC.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }

    // MARK: - Core Data Saving support

    func saveMainMOC() {
        if mainMOC.hasChanges {
            do {
                try mainMOC.save()
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
                    $0.toAnswerModel(string: $0.answer ?? "", date: $0.timestamp ?? Date(), uuid: $0.uuid ?? UUID())
                } ?? results
            } catch {
                print(error)
            }
        }

        return results
    }

    func save(answer: AnswerModel) {
        backgroundMOC.performAndWait {
            let modelObject = ManagedAnswer(context: backgroundMOC)
            modelObject.answer = answer.answer
            modelObject.timestamp = answer.timestamp
            modelObject.uuid = answer.uuid
            saveBackgroundMOC()
        }
    }

    func delete(answer: AnswerModel) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedAnswer")
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", answer.uuid as NSUUID)

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

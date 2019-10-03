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
    func saveContext(answer: AnswerModel)
}

class PersistenceService: PersistenceStore {

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Yalantis_School")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext

    // MARK: - Core Data Saving support

    func save() {
        if context.hasChanges {
            do {
                try context.save()
                print("Saved")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetch() -> [AnswerModel] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedAnswer")
        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [ManagedAnswer]
            return fetchedObjects?.map { $0.toAnswerModel(string: $0.answer ?? "1") } ?? [AnswerModel]()
            } catch {
            print(error)
            return [AnswerModel]()
        }
    }

    func saveContext(answer: AnswerModel) {
          let modelObject = ManagedAnswer(context: context)
          modelObject.answer = answer.answer
          save()
    }
}

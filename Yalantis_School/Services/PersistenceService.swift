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

        /*add necessary support for migration*/
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions.append(description)
        /*add necessary support for migration*/

        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var mainMOC = persistentContainer.viewContext
    lazy var backgroundMOC = persistentContainer.newBackgroundContext()

    // MARK: - Core Data Saving support

    func save() {
        mainMOC.automaticallyMergesChangesFromParent = true
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
/*  Лекция 7, слайд 36
     Какой смысл в фетче через fetchedResultController если при условии 3х слойной архитектуры на выходе я получу PresentableModel, только для делеагата и таблицы?
     И правильно ли я понимаю что это будут разные функции: для таблицы fetchToTableView, для главного экрана fetch?
     Как лучше протянуть делегат с PersistenceService до класса с таблицей?(как я понял импорт CoreData куда либо кроме CoreData service отпадает)
     Лекция 8, слайд 11
     Я не разобрался зачем нам проворачивать эти действия в ДЗ, возможно это просто пример но в чате кого-то этот вопрос интересовал.
     
     
     
    func fetchToTableView() -> [AnswerModel] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedAnswer")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        let fetchresult = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: backgroundMOC,
            sectionNameKeyPath: nil,
            cacheName: nil)

        do {
            try fetchresult.performFetch()
            let result = fetchresult.fetchedObjects as? [ManagedAnswer]
            return result?.map { $0.toAnswerModel(string: $0.answer ?? "", date: $0.timestamp!) } ?? [AnswerModel]()
        } catch {
            print(error)
            return [AnswerModel]()
        }
    }
 */

    func fetch() -> [AnswerModel] {
        var results = [AnswerModel]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedAnswer")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]

        backgroundMOC.performAndWait {
            do {
                let fetchedObjects = try backgroundMOC.fetch(fetchRequest) as? [ManagedAnswer]
                results = fetchedObjects!.map { $0.toAnswerModel(string: $0.answer ?? "", date: $0.timestamp!) }
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
            save()
        }
    }

    func delete(answer: AnswerModel) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedAnswer")
        fetchRequest.predicate = NSPredicate(format: "answer == %@", answer.answer)
        backgroundMOC.performAndWait {
            do {
                let fetchedObjects = try backgroundMOC.fetch(fetchRequest) as? [NSManagedObject]
                backgroundMOC.delete((fetchedObjects?.first!)!)
                save()
            } catch {
                print(error)
            }
        }

    }
}

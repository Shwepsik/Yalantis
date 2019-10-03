//
//  ManagedAnswer+CoreDataProperties.swift
//  Yalantis_School
//
//  Created by Valerii on 8/18/19.
//  Copyright © 2019 Valerii. All rights reserved.
//
//

import Foundation
import CoreData

extension ManagedAnswer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedAnswer> {
        return NSFetchRequest<ManagedAnswer>(entityName: "ManagedAnswer")
    }

    func toAnswerModel(string: String) -> AnswerModel {
        return AnswerModel(answer: string)
    }

    @NSManaged public var answer: String?
}

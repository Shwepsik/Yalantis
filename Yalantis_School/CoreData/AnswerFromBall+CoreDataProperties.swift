//
//  AnswerFromBall+CoreDataProperties.swift
//  Yalantis_School
//
//  Created by Valerii on 8/18/19.
//  Copyright © 2019 Valerii. All rights reserved.
//
//

import Foundation
import CoreData

extension AnswerFromBall {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AnswerFromBall> {
        return NSFetchRequest<AnswerFromBall>(entityName: "AnswerFromBall")
    }

    @NSManaged public var answer: String?

}

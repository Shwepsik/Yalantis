//
//  PresentableAnswer.swift
//  Yalantis_School
//
//  Created by Valerii on 10/3/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import RxDataSources

struct PresentableAnswer {

    var answer: String
    var timestamp: String?
    var uuid: UUID?
}

extension PresentableAnswer: IdentifiableType, Equatable {

    typealias Identity = UUID

    var identity: Identity {
        return uuid ?? UUID()
    }

    static func == (lhs: PresentableAnswer, rhs: PresentableAnswer) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func toAnswerModel(answer: String, date: Date, uuid: UUID) -> AnswerModel {
        return AnswerModel(answer: answer, timestamp: date, uuid: uuid)
    }
}

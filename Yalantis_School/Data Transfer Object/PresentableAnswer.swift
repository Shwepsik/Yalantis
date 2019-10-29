//
//  PresentableAnswer.swift
//  Yalantis_School
//
//  Created by Valerii on 10/3/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import RxDataSources

class PresentableAnswer {

    var answer: String
    var timestamp: String
    var uuid: UUID

    init(answer: String, timestamp: String, uuid: UUID) {
        self.answer = answer
        self.timestamp = timestamp
        self.uuid = uuid
    }
}

extension PresentableAnswer: IdentifiableType, Equatable {

    typealias Identity = UUID

    var identity: Identity {
        return uuid
    }

    static func == (lhs: PresentableAnswer, rhs: PresentableAnswer) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func toAnswerModel(answer: String, date: Date, uuid: UUID) -> AnswerModel {
        return AnswerModel(answer: answer, timestamp: date, uuid: uuid)
    }
}

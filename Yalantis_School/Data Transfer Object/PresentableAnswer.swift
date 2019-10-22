//
//  PresentableAnswer.swift
//  Yalantis_School
//
//  Created by Valerii on 10/3/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation

struct PresentableAnswer {

    var answer: String
    var timestamp: String?
    var uuid: UUID?
}

extension PresentableAnswer {

    func toAnswerModel(answer: String, date: Date, uuid: UUID) -> AnswerModel {
        return AnswerModel(answer: answer, timestamp: date, uuid: uuid)
    }
}

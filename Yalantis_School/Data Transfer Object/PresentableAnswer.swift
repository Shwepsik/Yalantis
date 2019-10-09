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
}

extension PresentableAnswer {

    func toAnswerModel(string: String) -> AnswerModel {
        return AnswerModel(answer: string)
    }
}

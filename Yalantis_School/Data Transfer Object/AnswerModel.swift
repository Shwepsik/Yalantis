//
//  AnswerModel.swift
//  Yalantis_School
//
//  Created by Valerii on 8/18/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation

struct AnswerModel {

    enum RootKey: CodingKey {
        case magic
    }

    enum AnswerKey: CodingKey {
        case answer
    }

    var answer: String
    var timestamp: Date
}

extension AnswerModel: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let answerContainer = try container.nestedContainer(keyedBy: AnswerKey.self, forKey: .magic)
        self.answer = try answerContainer.decode(type(of: self.answer), forKey: .answer)
        self.timestamp = Date()
    }

    func toPresentableAnswer(string: String, date: String) -> PresentableAnswer {
        return PresentableAnswer(answer: string, timestamp: date)
    }
}

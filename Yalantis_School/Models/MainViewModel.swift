//
//  MainViewModel.swift
//  Yalantis_School
//
//  Created by Valerii on 9/29/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation

typealias PresentableAnswerResponse = (_ result: PresentableAnswer?) -> Void
typealias PresentableShakeResponse = (_ result: PresentableShakeCount) -> Void

class MainViewModel {

   private let mainModel: MainModel
   private(set) lazy var formatter = DateFormatter()

    init(mainModel: MainModel) {
        self.mainModel = mainModel
    }

    func createPhrase() {
        mainModel.createPhrase()
    }

    func getAnswer(question: String, response: @escaping(PresentableAnswerResponse)) {
        mainModel.getAnswer(question) { (answer) in
            let presentableAnswer = answer?.toPresentableAnswer(
                string: answer?.answer.uppercased() ?? "",
                date: self.string(from: answer?.timestamp ?? Date()),
                uuid: answer!.uuid
            )
            response(presentableAnswer)
        }
    }

    func fetchAllAnswers() -> [PresentableAnswer] {
        let presentableAnswer = mainModel.fetchAllAnswers().map {
            $0.toPresentableAnswer(string: $0.answer.uppercased(), date: self.string(from: $0.timestamp), uuid: $0.uuid)
        }
        return presentableAnswer
    }

    func savePharse(presentableAnswer: PresentableAnswer) {
        let answerModel = presentableAnswer.toAnswerModel(answer: presentableAnswer.answer, date: Date(), uuid: UUID())
        mainModel.save(answerModel)
    }

    func addShakeCount() {
        mainModel.addShakeCount()
    }

    func getShakeCount(_ completion: @escaping(PresentableShakeResponse)) {
        mainModel.getShake { (shake) in
            let presentableShakeCount = shake.toPresentableShakeCount(intenger: shake.shakeCount)
            completion(presentableShakeCount)
        }
    }

    func delete(presentableAnswer: PresentableAnswer) {
        let answerModel = presentableAnswer.toAnswerModel(
            answer: presentableAnswer.answer.lowercased(),
            date: date(from: presentableAnswer.timestamp ?? ""),
            uuid: presentableAnswer.uuid ?? UUID()
        )
        mainModel.delete(answerModel)
    }

    func string(from date: Date) -> String {
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let result = formatter.string(from: date)
        return result
    }

    func date(from string: String) -> Date {
        let result = formatter.date(from: string)
        return result ?? Date()
    }
}

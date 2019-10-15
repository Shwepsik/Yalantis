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
                date: self.dateToString(date: answer?.timestamp ?? Date())
            )
            response(presentableAnswer)
        }
    }

    func fetchAllAnswers() -> [PresentableAnswer] {
        let presentableAnswer = mainModel.fetchAllAnswers().map {
            $0.toPresentableAnswer(string: $0.answer.uppercased(), date: self.dateToString(date: $0.timestamp))
        }
        return presentableAnswer
    }

    func savePharse(presentableAnswer: PresentableAnswer) {
        let answerModel = presentableAnswer.toAnswerModel(answer: presentableAnswer.answer, date: Date())
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

    // Не добавлял форматирование с presentableAnswer.timestamp (string) в Date т.к делаю Predicate по ответу и в данном случае мне не важно какой Date(), если так лучше не делать то добавлю
    func delete(presentableAnswer: PresentableAnswer) {
        let answerModel = presentableAnswer.toAnswerModel(answer: presentableAnswer.answer.lowercased(), date: Date())
        mainModel.delete(answerModel)
    }

    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let result = formatter.string(from: date)
        return result
    }
}

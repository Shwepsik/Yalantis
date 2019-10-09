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
            let presentableAnswer = answer?.toPresentableAnswer(string: answer?.answer.uppercased() ?? "")
            response(presentableAnswer)
        }
    }

    func savePharse(presentableAnswer: PresentableAnswer) {
        let answerModel = presentableAnswer.toAnswerModel(string: presentableAnswer.answer)
        mainModel.save(answerModel)
    }

    func addShakeCount() {
        mainModel.addShakeCount()
    }

    func getShakeCount(response: @escaping(PresentableShakeResponse)) {
        mainModel.getShake { (shake) in
            let presentableShakeCount = shake.toPresentableShakeCount(intenger: shake.shakeCount)
            response(presentableShakeCount)
        }
    }
}

//
//  MainModel.swift
//  Yalantis_School
//
//  Created by Valerii on 9/29/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation

class MainModel {

    let dataFetcher: DataFetcher
    let persistenceService: PersistenceService

    init(dataFetcher: DataFetcher, persistenceService: PersistenceService) {
        self.dataFetcher = dataFetcher
        self.persistenceService = persistenceService
    }

    func getAnswer(_ path: String, _ response: @escaping (Response)) {
        dataFetcher.tryLoadAnswer(path) { (answer, error) in
            if error != nil {
                let answers = self.persistenceService.fetch(AnswerFromBall.self)
                let offlineAnswer = answers[Int(arc4random_uniform(UInt32(answers.count)))].answer
                response(offlineAnswer)
            } else {
                let uppercaseString = self.uppercasseString(answer: answer!)
                response(uppercaseString)
            }
        }
    }

    func uppercasseString(answer: String) -> String {
        let answer = answer.uppercased()
        return answer
    }

    func createPhrase() {
        let answersPack = persistenceService.fetch(AnswerFromBall.self)
        let phrases = ["Try to think about it tomorrow", "Great idea!", "Burn them all",
                       "It’s better to wait a little", "Ask your heart"]

        if answersPack.count == 0 {
            phrases.forEach { (phrase) in
                let answers = AnswerFromBall(context: persistenceService.context)
                answers.answer = uppercasseString(answer: phrase)
            }
        }
    }

    func savePhrase(_ answerTextField: String) {
        let answersPack = AnswerFromBall(context: persistenceService.context)
        answersPack.answer = uppercasseString(answer: answerTextField)
        persistenceService.save()
    }
}

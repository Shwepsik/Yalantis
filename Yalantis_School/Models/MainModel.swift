//
//  MainModel.swift
//  Yalantis_School
//
//  Created by Valerii on 9/29/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation

typealias AnswerModelResponse = (_ result: AnswerModel?) -> Void

class MainModel {

   private let dataFetcher: DataFetching
   private let persistenceService: PersistenceStore

    init(dataFetcher: DataFetching, persistenceService: PersistenceStore) {
        self.dataFetcher = dataFetcher
        self.persistenceService = persistenceService
    }

    func getAnswer(_ path: String, _ response: @escaping (AnswerModelResponse)) {
        dataFetcher.tryLoadAnswer(path) { (answer, error) in
            if error != nil {
                let answers = self.persistenceService.fetch()
                let offlineAnswer = answers[Int(arc4random_uniform(UInt32(answers.count)))]
                response(offlineAnswer)
            } else {
                response(answer)
            }
        }
    }

    func createPhrase() {
        let answersPack = persistenceService.fetch()
        let phrases = ["Try to think about it tomorrow", "Great idea!", "Burn them all",
                       "It’s better to wait a little", "Ask your heart"]

        if answersPack.count == 0 {
            phrases.forEach { (phrase) in
                let answer = AnswerModel(answer: phrase)
                persistenceService.saveContext(answer: answer)
            }
        }
    }

    func savePhrase(_ answerModel: AnswerModel) {
        persistenceService.saveContext(answer: answerModel)
    }
}

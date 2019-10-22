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
   private let keyChainService: SecureStorage
   let timestamp = Date()

    init(dataFetcher: DataFetching, persistenceService: PersistenceStore, keyChainService: SecureStorage) {
        self.dataFetcher = dataFetcher
        self.persistenceService = persistenceService
        self.keyChainService = keyChainService
    }

    func getAnswer(_ path: String, _ response: @escaping (AnswerModelResponse)) {
        dataFetcher.tryLoadAnswer(path) { (answer, error) in
            if error != nil {
                let answers = self.persistenceService.fetch()
                let offlineAnswer = answers[Int(arc4random_uniform(UInt32(answers.count)))]
                response(offlineAnswer)
            } else {
                guard let answer = answer else { return }
                self.save(answer)
                response(answer)
            }
        }
    }

    func addShakeCount() {
        keyChainService.addShakeCount()
    }

    func getShake(response: @escaping (ShakeCountModelResponse)) {
        keyChainService.getShakeCount(response)
    }

    func createPhrase() {
        let answersPack = persistenceService.fetch()
        let phrases = ["Try to think about it tomorrow", "Great idea!", "Burn them all",
                       "It’s better to wait a little", "Ask your heart"]

        if answersPack.count == 0 {
            phrases.forEach { (phrase) in
                let answer = AnswerModel(answer: phrase, timestamp: timestamp, uuid: UUID())
                save(answer)
            }
        }
    }

    func fetchAllAnswers() -> [AnswerModel] {
        let answerPack = persistenceService.fetch()
        return answerPack
    }

    func save(_ answerModel: AnswerModel) {
        persistenceService.save(answer: answerModel)
    }

    func delete(_ answerModel: AnswerModel) {
        persistenceService.delete(answer: answerModel)
    }
}

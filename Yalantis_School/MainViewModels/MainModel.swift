//
//  MainModel.swift
//  Yalantis_School
//
//  Created by Valerii on 9/29/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class MainModel {

    private let dataFetcher: DataFetching
    private let persistenceService: PersistenceStore
    private let keyChainService: SecureStorage
    private let disposeBag = DisposeBag()
    let getShakeCount = PublishSubject<Void>()
    let shakeAction = PublishSubject<Void>()
    let shouldStartAnimation = PublishSubject<Bool>()
    let shakesCount = BehaviorRelay<ShakeCountModel>(value: ShakeCountModel(shakeCount: 0))
    let answer = PublishSubject<AnswerModel>()

    init(dataFetcher: DataFetching, persistenceService: PersistenceStore, keyChainService: SecureStorage) {
        self.dataFetcher = dataFetcher
        self.persistenceService = persistenceService
        self.keyChainService = keyChainService
        self.setupBindings()
    }

    private func setupBindings() {
        getShakeCount.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.shakesCount.accept(self.keyChainService.getShakeCount())
        }).disposed(by: disposeBag)

        shakeAction.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.shouldStartAnimation.onNext(true)
            self.addShakeCount()
            self.shakesCount.accept(self.keyChainService.getShakeCount())
        }).disposed(by: disposeBag)
    }

    func getAnswer(_ path: String) {
        dataFetcher.tryLoadAnswer(path) { (answer, error) in
            if error != nil {
                let answers = self.persistenceService.fetch()
                let offlineAnswer = answers[Int(arc4random_uniform(UInt32(answers.count)))]
                self.answer.onNext(offlineAnswer)
                self.shouldStartAnimation.onNext(false)
            } else {
                guard let answer = answer else { return }
                self.answer.onNext(answer)
                self.shouldStartAnimation.onNext(false)
                self.save(answer)
            }
        }
    }

    private func addShakeCount() {
        keyChainService.addShakeCount()
    }

    func createPhrase() {
        let timestamp = Date()
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

    private func save(_ answerModel: AnswerModel) {
        persistenceService.save(answer: answerModel)
    }
}

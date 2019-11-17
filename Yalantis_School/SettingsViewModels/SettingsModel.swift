//
//  SettingsModel.swift
//  Yalantis_School
//
//  Created by Valerii on 10/31/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class SettingsModel {

    private let persistenceService: PersistenceStore
    private let disposeBag = DisposeBag()
    let answersPack = PublishSubject<[AnswerModel]>()
    let answerToDelete = PublishSubject<AnswerModel>()
    let answerToAdd = PublishSubject<AnswerModel>()

    init(persistenceService: PersistenceService) {
        self.persistenceService = persistenceService
        self.setupBindings()
    }

    private func setupBindings() {
        answerToDelete.subscribe(onNext: { [weak self] (answer) in
            guard let self = self else { return }
            self.delete(answer)
        }).disposed(by: disposeBag)

        answerToAdd.subscribe(onNext: { [weak self] (answer) in
            guard let self = self else { return }
            self.save(answer)
        }).disposed(by: disposeBag)
    }

    func fetchAnswers() {
        let fetchedAnswers = persistenceService.fetch()
        answersPack.onNext(fetchedAnswers)
    }

    private func save(_ answerModel: AnswerModel) {
        persistenceService.save(answer: answerModel)
    }

    private func delete(_ answerModel: AnswerModel) {
        persistenceService.delete(answer: answerModel)
    }
}

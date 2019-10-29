//
//  MainViewModel.swift
//  Yalantis_School
//
//  Created by Valerii on 9/29/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class MainViewModel {

    private let mainModel: MainModel
    private(set) lazy var formatter = DateFormatter()
    private let disposeBag = DisposeBag()
    let shouldUpdateAnswer = PublishSubject<PresentableAnswer>()
    let shouldUpdateShakeCount = PublishSubject<PresentableShakeCount>()
    let shouldStartAnimation = BehaviorSubject<Bool>(value: false)
    let shakeAction = PublishSubject<Void>()
    let getShakeCount = PublishSubject<Void>()
    let shouldFetchAnswers = BehaviorSubject<[PresentableAnswer]>(value: [])
    let shouldDeleteAnswer = PublishSubject<PresentableAnswer>()
    let shouldAddAnswer = PublishSubject<PresentableAnswer>()

    init(mainModel: MainModel) {
        self.mainModel = mainModel
        setupBindings()
    }

    func createPhrase() {
        mainModel.createPhrase()
    }

    func getAnswer(question: String) {
        mainModel.getAnswer(question)
    }

    private func setupBindings() {
        mainModel.shouldUpdateAnswer.subscribe(onNext: { [weak self] (answer) in
            guard let self = self else { return }
            let presentableAnswer = answer.toPresentableAnswer(
                string: answer.answer.uppercased(),
                date: self.string(from: answer.timestamp),
                uuid: answer.uuid
            )
            self.shouldUpdateAnswer.onNext((presentableAnswer))
        }).disposed(by: disposeBag)

        shouldDeleteAnswer.subscribe(onNext: { [weak self] (presentableAnswer) in
            guard let self = self else { return }
            let answer = presentableAnswer.toAnswerModel(
                answer: presentableAnswer.answer.lowercased(),
                date: self.date(from: presentableAnswer.timestamp ),
                uuid: presentableAnswer.uuid
            )
            self.mainModel.shouldDeleteAnswer.onNext(answer)
            }).disposed(by: disposeBag)

        shouldAddAnswer.subscribe(onNext: { [weak self] (presentableAnswer) in
            guard let self = self else { return }
            let answer = presentableAnswer.toAnswerModel(
                answer: presentableAnswer.answer,
                date: Date(),
                uuid: UUID())
            self.mainModel.shouldAddAnswer.onNext(answer)
        }).disposed(by: disposeBag)

        getShakeCount.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.mainModel.getShakeCount.onNext(())
        }).disposed(by: disposeBag)

        mainModel.shouldUpdateShakeCount.subscribe(onNext: { [weak self] (count) in
            guard let self = self else { return }
            let presentableShakeCount = count.toPresentableShakeCount(intenger: count.shakeCount)
            self.shouldUpdateShakeCount.onNext(presentableShakeCount)
        }).disposed(by: disposeBag)

        shakeAction.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.mainModel.shakeAction.onNext(())
        }).disposed(by: disposeBag)

        mainModel.shouldStartAnimation.subscribe(onNext: { [weak self] (isFinish) in
            guard let self = self else { return }
            self.shouldStartAnimation.onNext(isFinish)
        }).disposed(by: disposeBag)

        mainModel.shouldFetchAnswers.subscribe(onNext: { [weak self] (answer) in
            guard let self = self else { return }
            let presentableAnswer = answer.map { $0.toPresentableAnswer(
                string: $0.answer.uppercased(),
                date: self.string(from: $0.timestamp),
                uuid: $0.uuid)
            }
            self.shouldFetchAnswers.onNext(presentableAnswer)
        }).disposed(by: disposeBag)
    }

    func fetchAnswers() {
        mainModel.fetchAnswers()
    }

    func deleteAnswer(by indexPath: IndexPath) {
        guard var sections = try? shouldFetchAnswers.value() else { return }
        shouldDeleteAnswer.onNext(sections[indexPath.row])
        sections.remove(at: indexPath.row)
        shouldFetchAnswers.onNext(sections)
    }

    func addShakeCount() {
        mainModel.addShakeCount()
    }

    private func string(from date: Date) -> String {
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let result = formatter.string(from: date)
        return result
    }

    private func date(from string: String) -> Date {
        let result = formatter.date(from: string)
        return result ?? Date()
    }
}

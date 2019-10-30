//
//  MainViewModel.swift
//  Yalantis_School
//
//  Created by Valerii on 9/29/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class MainViewModel {

    private let mainModel: MainModel
    private(set) lazy var formatter = DateFormatter()
    private let disposeBag = DisposeBag()
    let shouldStartAnimation = PublishSubject<Bool>()
    let shakeAction = PublishSubject<Void>()
    let getShakeCount = PublishSubject<Void>()
    let answerToAdd = PublishSubject<PresentableAnswer>()
    let answerFromApi = PublishSubject<PresentableAnswer>()
    let shakesCount = BehaviorRelay<PresentableShakeCount?>(value: nil)

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
        mainModel.answerFromApi.subscribe(onNext: { [weak self] (answer) in
            guard let self = self else { return }
            let presentableAnswer = answer.toPresentableAnswer(
                string: answer.answer.uppercased(),
                date: self.string(from: answer.timestamp),
                uuid: answer.uuid
            )
            self.answerFromApi.onNext((presentableAnswer))
        }).disposed(by: disposeBag)

        getShakeCount.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.mainModel.getShakeCount.onNext(())
        }).disposed(by: disposeBag)

        mainModel.shakesCount.bind { (count) in
            guard let count = count else { return }
            let presentableShakeCount = count.toPresentableShakeCount(intenger: count.shakeCount)
            self.shakesCount.accept(presentableShakeCount)
        }.disposed(by: disposeBag)

        shakeAction.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.mainModel.shakeAction.onNext(())
        }).disposed(by: disposeBag)

        mainModel.shouldStartAnimation.bind(to: shouldStartAnimation).disposed(by: disposeBag)
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

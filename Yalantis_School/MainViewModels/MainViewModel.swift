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
    let answer = PublishSubject<PresentableAnswer>()
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
//        mainModel.answer.subscribe(onNext: { [weak self] (answer) in
//            guard let self = self else { return }
//            let presentableAnswer = answer.toPresentableAnswer(
//                string: answer.answer.uppercased(),
//                date: self.string(from: answer.timestamp),
//                uuid: answer.uuid
//            )
//            self.answerFromApi.onNext((presentableAnswer))
//        }).disposed(by: disposeBag)

        mainModel.answer
            .map { $0.toPresentableAnswer(
                string: $0.answer.uppercased(),
                date: self.string(from: $0.timestamp),
                uuid: $0.uuid
                )
            }
            .bind(to: answer)
            .disposed(by: disposeBag)

        getShakeCount.bind(to: mainModel.getShakeCount).disposed(by: disposeBag)

        shakeAction.bind(to: mainModel.shakeAction).disposed(by: disposeBag)

        mainModel.shakesCount
            .map { $0.toPresentableShakeCount(intenger: $0.shakeCount) }
            .bind(to: shakesCount)
            .disposed(by: disposeBag)

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

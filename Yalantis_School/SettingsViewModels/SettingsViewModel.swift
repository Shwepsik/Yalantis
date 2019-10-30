//
//  SettingsViewModel.swift
//  Yalantis_School
//
//  Created by Valerii on 10/31/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class SettingsViewModel {

    private let settingsModel: SettingsModel
    private(set) lazy var formatter = DateFormatter()
    private let disposeBag = DisposeBag()
    let answerToDelete = PublishSubject<PresentableAnswer>()
    let answerToAdd = PublishSubject<PresentableAnswer>()

    let answersPack = BehaviorSubject<[PresentableAnswer]>(value: [])

    init(settingsModel: SettingsModel) {
        self.settingsModel = settingsModel
        setupBindings()
    }

    func setupBindings() {
        settingsModel.answersPack.subscribe(onNext: { [weak self] (answer) in
            guard let self = self else { return }
            let presentableAnswer = answer.map { $0.toPresentableAnswer(
                string: $0.answer.uppercased(),
                date: self.string(from: $0.timestamp),
                uuid: $0.uuid)
            }
            self.answersPack.onNext(presentableAnswer)
        }).disposed(by: disposeBag)

        answerToDelete.subscribe(onNext: { [weak self] (presentableAnswer) in
            guard let self = self else { return }
            let answer = presentableAnswer.toAnswerModel(
                answer: presentableAnswer.answer.lowercased(),
                date: self.date(from: presentableAnswer.timestamp ?? ""),
                uuid: presentableAnswer.uuid ?? UUID()
            )
            self.settingsModel.answerToDelete.onNext(answer)
        }).disposed(by: disposeBag)

        answerToAdd.subscribe(onNext: { [weak self] (presentableAnswer) in
            guard let self = self else { return }
            let answer = presentableAnswer.toAnswerModel(
                answer: presentableAnswer.answer,
                date: Date(),
                uuid: UUID()
            )
            self.settingsModel.answerToAdd.onNext(answer)
        }).disposed(by: disposeBag)
    }

    func deleteAnswer(by indexPath: IndexPath) {
        guard var sections = try? answersPack.value() else { return }
        answerToDelete.onNext(sections[indexPath.row])
        sections.remove(at: indexPath.row)
        answersPack.onNext(sections)
    }

    func fetchAnswers() {
        settingsModel.fetchAnswers()
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

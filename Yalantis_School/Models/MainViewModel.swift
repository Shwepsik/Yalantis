//
//  MainViewModel.swift
//  Yalantis_School
//
//  Created by Valerii on 9/29/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation

class MainViewModel {

    let mainModel: MainModel

    init(mainModel: MainModel) {
        self.mainModel = mainModel
    }

    func createPhrase() {
        mainModel.createPhrase()
    }

    func getAnswer(question: String, response: @escaping(Response)) {
        mainModel.getAnswer(question) { (answer) in
            response(answer)
        }
    }

    func savePharse(answerTextFieldText: String, response: () -> Void) {
        mainModel.savePhrase(answerTextFieldText)
        response()
    }
}

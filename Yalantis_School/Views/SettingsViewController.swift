//
//  SettingsViewController.swift
//  Yalantis_School
//
//  Created by Valerii on 8/18/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import UIKit

class SettingsViewController: BackgroundViewController {
    
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = "Here you can create your own answers"
            descriptionLabel.textColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tapToHide()
    }
    
    @IBAction func addPhrase(_ sender: Any) {
        saveSome()
    }
    
    
    func saveSome() {
        if answerTextField.text!.isEmpty {
            self.showAlert(title: "Please add some text", messgae: "", style: .alert)
        } else {
             /*
             Введеные пользователем ответы не сохраняются в БД. Каждый запуск контекст заполняется одними и теми же данными в методе createPhrase(). Этого быть не должно, введенные и подготовленные ответы должны записываться в базу единожды.
             В коде есть проверка "if answersPack.count == 0", она никогда не даст false. (из фидбека)
            */
            let answersPack = AnswerFromBall(context: PersistenceService.shared.context)
            answersPack.answer = answerTextField.text!
            PersistenceService.shared.save()
            /*
            Вне зависимости будет вызван этот метод или нет, данные будут записаны для текущей сессии, т.к я редактирую Entity CoreData
             
            Пользователь может сворачивать приложение сколько угодно раз и Entity не потеряет свои данные
             
            После того как пользователь закроет приложение будет вызван метод который сохранит данные в БД
             
            func applicationWillTerminate(_ application: UIApplication) {
            PersistenceService.shared.save()
            }
             
            Пользователь попадает в createPhrase() только сразу после установки и никогда больше как с этим методом так и без него
            */
            self.answerTextField.text = ""
            self.showAlert(title: "Perfect", messgae: "", style: .alert)
        }
    }
}


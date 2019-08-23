//
//  ViewController.swift
//  Yalantis_School
//
//  Created by Valerii on 8/18/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import UIKit

class MainViewController: BackgroundViewController {
    
    
    let request = RequestController()
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerLabel: UILabel! {
        didSet {
            answerLabel.text = "Shake me to get the answer"
            answerLabel.textColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createPhrase()
        self.hideKeyboard()
        self.becomeFirstResponder()
    }
    
    func createPhrase() {
        let answersPack = PersistenceService.shared.fetch(AnswerFromBall.self)
        let phrases = ["Try to think about it tomorrow", "Great idea!", "Burn them all", "It’s better to wait a little", "Ask your heart"]
        /*
         Введеные пользователем ответы не сохраняются в БД. Каждый запуск контекст заполняется одними и теми же данными в методе createPhrase(). Этого быть не должно, введенные и подготовленные ответы должны записываться в базу единожды. (из фидбека)
         */
        
        if answersPack.count == 0 {
            
            // Сюда пользователь попадает только при первом запуске
            
            phrases.forEach { (phrase) in
                let answers = AnswerFromBall(context: PersistenceService.shared.context)
                answers.answer = phrase
            }
        } else {
            /*
             В коде есть проверка "if answersPack.count == 0", она никогда не даст false. (из фидбека)
             
             Пользователь попадет сюда после того как полностью закроет приложение и откроет снова, т.к после того как он закроет приложение будет вызван метод из AppDelegate который сохранит его изменения в базу данных

            func applicationWillTerminate(_ application: UIApplication) {
            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
            // Saves changes in the application's managed object context before the application terminates.
             PersistenceService.shared.save()
             }
             */
           answerLabel.text = "Пользователь попал в False и количество ответов == \(answersPack.count)"
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            if questionTextField.text != "" {
                request.tryLoadAnswer(questionTextField.text!) { (answer, error) in
                    if error != nil {
                        let answers = PersistenceService.shared.fetch(AnswerFromBall.self)
                        self.answerLabel.text = answers[Int(arc4random_uniform(UInt32(answers.count)))].answer
                        self.questionTextField.text = ""
                    } else {
                        let answers = PersistenceService.shared.fetch(AnswerFromBall.self)
                        answers.forEach{ print("Ответы которые лежат в базе данных == \($0.answer ?? "Some Text")") }
                        self.answerLabel.text = answer as? String
                        self.questionTextField.text = ""
                    }
                }
            } else {
                self.showAlert(title: "Please add some text", messgae: "", style: .alert)
            }
        }
    }
}

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
        self.tapToHide()
        self.becomeFirstResponder()
    }
    
    func createPhrase() {
        let answersPack = PersistenceService.shared.fetch(AnswerFromBall.self)
        let phrases = ["Try to think about it tomorrow", "Great idea!", "Burn them all", "It’s better to wait a little", "Ask your heart"]
        
        if answersPack.count == 0 {
            phrases.forEach { (phrase) in
                let answers = AnswerFromBall(context: PersistenceService.shared.context)
                answers.answer = phrase
            }
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
                        // Принт для проверки БД без метода PersistenceService.shared.save()
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

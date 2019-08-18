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
        self.hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backBarButtonItem?.title = ""
    }
    
    @IBAction func addPhrase(_ sender: Any) {
        saveSome()
    }
    
    
    func saveSome() {
        if answerTextField.text!.isEmpty {
            self.showAlert(title: "Please add some text", messgae: "", style: .alert)
        } else {
            let answersPack = AnswerFromBall(context: PersistenceService.shared.context)
            answersPack.answer = answerTextField.text!
            self.answerTextField.text = ""
            self.showAlert(title: "Perfect", messgae: "", style: .alert)
        }
    }
}


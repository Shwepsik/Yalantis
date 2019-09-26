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
            descriptionLabel.text = L10n.descriptionLabelText
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
            self.showAlert(title: L10n.addSomeText, messgae: "", style: .alert)
        } else {
            let answersPack = AnswerFromBall(context: PersistenceService.shared.context)
            answersPack.answer = answerTextField.text!
            PersistenceService.shared.save()
            self.answerTextField.text = ""
            self.showAlert(title: L10n.perfect, messgae: "", style: .alert)
        }
    }
}

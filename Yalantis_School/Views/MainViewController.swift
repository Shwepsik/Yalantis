//
//  ViewController.swift
//  Yalantis_School
//
//  Created by Valerii on 8/18/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import UIKit

class MainViewController: BackgroundViewController {

    var mainViewModel: MainViewModel!

    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerLabel: UILabel! {
        didSet {
            answerLabel.text = L10n.answerLabelText
            answerLabel.textColor = .white
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBarButtonItem()
        self.mainViewModel.createPhrase()
        self.tapToHide()
        self.becomeFirstResponder()
    }

    func addBarButtonItem() {
        let button = UIBarButtonItem(image: Asset.settings.image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(pushSettingsController))
        self.navigationItem.rightBarButtonItem = button
    }

    @objc func pushSettingsController() {
        let settingsViewController = StoryboardScene.Main.settingsViewController.instantiate()
        settingsViewController.mainViewModel = mainViewModel
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if questionTextField.text != "" {
                mainViewModel.getAnswer(question: questionTextField.text!) { (answer) in
                    self.questionTextField.text = ""
                    self.answerLabel.text = answer?.answer
                }
            } else {
                self.showAlert(title: L10n.addSomeText, messgae: "", style: .alert)
            }
        }
    }
}

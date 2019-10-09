//
//  ViewController.swift
//  Yalantis_School
//
//  Created by Valerii on 8/18/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: BackgroundViewController {

    var mainViewModel: MainViewModel!

    let questionTextField = UITextField()
    let answerLabel = UILabel()
    let shakeCountsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getShakeCounts()
        self.addOutlets()
        self.addBarButtonItem()
        self.mainViewModel.createPhrase()
        self.tapToHide()
        self.becomeFirstResponder()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.addConstraints()
    }

    func addBarButtonItem() {
        let button = UIBarButtonItem(image: Asset.settings.image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(pushSettingsController))
        self.navigationItem.rightBarButtonItem = button
    }

    @objc func pushSettingsController() {
        let settingsViewController = SettingsViewController()
        settingsViewController.mainViewModel = mainViewModel
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

     func addConstraints() {
        questionTextField.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.9)
        }
        answerLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(questionTextField)
            make.bottom.equalTo(questionTextField.snp.top).offset(-50)
            make.width.equalTo(questionTextField)
        }
        shakeCountsLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(15)
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            } else {
                make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(10)
            }
            make.width.equalTo(20)
            make.height.equalTo(40)
        }
    }

    func addOutlets() {
        //questionTextField
        questionTextField.placeholder = L10n.mainTextFieldPlaceholder
        questionTextField.textAlignment = .center
        questionTextField.borderStyle = .roundedRect
        questionTextField.font = FontFamily.SFProDisplay.regular.font(size: 15)
        self.view.addSubview(questionTextField)
        questionTextField.translatesAutoresizingMaskIntoConstraints = false
        //answerLabel
        answerLabel.text = L10n.answerLabelText
        answerLabel.textColor = .white
        answerLabel.textAlignment = .center
        answerLabel.font = FontFamily.SFProDisplay.regular.font(size: 17)
        self.view.addSubview(answerLabel)
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        //shakeCountsLabel
        shakeCountsLabel.backgroundColor = ColorName.navigationBarTitleColor.color
        shakeCountsLabel.textColor = .white
        shakeCountsLabel.textAlignment = .center
        shakeCountsLabel.font = FontFamily.SFProDisplay.regular.font(size: 17)
        self.view.addSubview(shakeCountsLabel)
        shakeCountsLabel.translatesAutoresizingMaskIntoConstraints = false

    }

    func getShakeCounts() {
        mainViewModel.getShakeCount { (shake) in
            self.shakeCountsLabel.text = shake.shakeCount
        }
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            mainViewModel.addShakeCount()
            if questionTextField.text != "" {
                mainViewModel.getAnswer(question: questionTextField.text!) { (answer) in
                    self.questionTextField.text = ""
                    self.answerLabel.text = answer?.answer
                }
            } else {
                self.showAlert(title: L10n.addSomeText, messgae: "", style: .alert)
            }
            self.getShakeCounts()
        }
    }
}

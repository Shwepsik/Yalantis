//
//  SettingsViewController.swift
//  Yalantis_School
//
//  Created by Valerii on 8/18/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import UIKit

class SettingsViewController: BackgroundViewController {

    var mainViewModel: MainViewModel!
    private let answerTextField = UITextField()
    private let descriptionLabel = UILabel()
    private let saveButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addOutlets()
        self.addConstraints()
        self.tapToHide()
    }

    private func addOutlets() {
        answerTextField.placeholder = L10n.settingsTextFieldPlaceholder
        answerTextField.textAlignment = .center
        answerTextField.borderStyle = .roundedRect
        answerTextField.font = FontFamily.SFProDisplay.regular.font(size: 15)
        view.addSubview(answerTextField)

        descriptionLabel.text = L10n.descriptionLabelText
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = FontFamily.SFProDisplay.regular.font(size: 17)
        view.addSubview(descriptionLabel)

        saveButton.setBackgroundImage(Asset.button.image, for: .normal)
        saveButton.setTitle(L10n.saveButton, for: .normal)
        saveButton.setTitleColor(ColorName.navigationBarTitleColor.color, for: .normal)
        saveButton.titleLabel?.font = FontFamily.SFProDisplay.medium.font(size: 17)
        saveButton.addTarget(self, action: #selector(savePhrase), for: .touchUpInside)
        view.addSubview(saveButton)
    }

    private func addConstraints() {
        answerTextField.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.9)
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(answerTextField)
            make.bottom.equalTo(answerTextField.snp.top).offset(-50)
            make.width.equalTo(answerTextField)
        }
        saveButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(answerTextField)
            make.top.equalTo(answerTextField.snp.bottom).offset(30)
            make.height.equalTo(40)
            make.width.equalTo(self.view).multipliedBy(0.33)
        }
    }

    @objc func savePhrase() {
        if answerTextField.text!.isEmpty {
            self.showAlert(title: L10n.addSomeText, messgae: "", style: .alert)
        } else {
            let answer = PresentableAnswer(answer: answerTextField.text!)
            mainViewModel.savePharse(presentableAnswer: answer)
            self.answerTextField.text = ""
            self.showAlert(title: L10n.perfect, messgae: "", style: .alert)
        }
    }
}

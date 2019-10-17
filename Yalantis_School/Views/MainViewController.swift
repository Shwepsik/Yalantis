//
//  ViewController.swift
//  Yalantis_School
//
//  Created by Valerii on 8/18/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    var mainViewModel: MainViewModel!

    private let questionTextField = UITextField()
    private let answerLabel = UILabel()
    private let shakeCountsLabel = UILabel()
    private let backgroundImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getShakeCounts()
        self.fillView()
        self.setupTabBarItem()
        self.addConstraints()
        self.mainViewModel.createPhrase()
        self.tapToHide()
        self.becomeFirstResponder()
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    private func setupTabBarItem() {
        self.tabBarItem = UITabBarItem(
        title: L10n.ball,
        image: Asset.ball.image,
        selectedImage: Asset.ball.image)
    }

    private func addConstraints() {
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

        backgroundImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }

    private func fillView() {
        self.title = L10n.navigationTitle
        backgroundImageView.image = Asset.sky.image
        backgroundImageView.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImageView, at: 0)

        questionTextField.placeholder = L10n.mainTextFieldPlaceholder
        questionTextField.textAlignment = .center
        questionTextField.borderStyle = .roundedRect
        questionTextField.font = FontFamily.SFProDisplay.regular.font(size: 15)
        view.addSubview(questionTextField)

        answerLabel.text = L10n.answerLabelText
        answerLabel.textColor = .white
        answerLabel.textAlignment = .center
        answerLabel.font = FontFamily.SFProDisplay.regular.font(size: 17)
        view.addSubview(answerLabel)

        shakeCountsLabel.backgroundColor = ColorName.navigationBarTitleColor.color
        shakeCountsLabel.textColor = .white
        shakeCountsLabel.textAlignment = .center
        shakeCountsLabel.font = FontFamily.SFProDisplay.regular.font(size: 17)
        view.addSubview(shakeCountsLabel)
    }

   private func getShakeCounts() {
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

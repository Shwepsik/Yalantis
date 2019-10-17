//
//  SettingsViewController.swift
//  Yalantis_School
//
//  Created by Valerii on 8/18/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var mainViewModel: MainViewModel!
    private var tableView = UITableView()
    private var answerInfo = [PresentableAnswer]()
    private var alertTextField = UITextField()
    private var answerPack = [PresentableAnswer]()
    private let cellReuseIdentifier = "SettingTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBarButtonItems()
        self.setupTableView()
        self.tapToHide()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        answerPack = mainViewModel.fetchAllAnswers()
        self.tableView.reloadData()
    }

    private func setupBarButtonItems() {
        self.title = L10n.navigationTitle
        let button = UIBarButtonItem(image: Asset.plus.image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(showAlertForSavePhrase))
        self.navigationItem.rightBarButtonItem = button

        self.tabBarItem = UITabBarItem(
        title: L10n.settings,
        image: Asset.settings.image,
        selectedImage: Asset.settings.image)
    }

    private func setupTableView() {
        self.tableView.register(SettingTableViewCell.classForCoder(), forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
        }
    }

    @objc func showAlertForSavePhrase() {
        let alert = UIAlertController(title: L10n.hereUCanAddOwnAnswer, message: "", preferredStyle: .alert)

        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = L10n.alertPlaceholder
            textField.font = FontFamily.SFProDisplay.regular.font(size: 15)
            textField.textAlignment = .center
            self.alertTextField = textField
        })

        let saveAction = UIAlertAction(title: L10n.saveButton, style: .default) { (_) in
            if let text = self.alertTextField.text, !text.isEmpty {
                let answer = PresentableAnswer(answer: self.alertTextField.text!)
                self.mainViewModel.savePharse(presentableAnswer: answer)
                self.answerPack = self.mainViewModel.fetchAllAnswers()
                self.tableView.reloadData()
            }
        }

        let cancelAction = UIAlertAction(title: L10n.cancelAction, style: .destructive, handler: nil)

        alert.addAction(cancelAction)
        alert.addAction(saveAction)

        present(alert, animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answerPack.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.answerLabel.text = answerPack[indexPath.row].answer
        cell.timeStampLabel.text = answerPack[indexPath.row].timestamp
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .left)
            mainViewModel.delete(presentableAnswer: answerPack[indexPath.row])
            answerPack.remove(at: indexPath.row)
            tableView.endUpdates()
        }
    }
}

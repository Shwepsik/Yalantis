//
//  SettingsViewController.swift
//  Yalantis_School
//
//  Created by Valerii on 8/18/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SettingsViewController: UIViewController {

    var settingsViewModel: SettingsViewModel!
    private var tableView = UITableView()
    private var alertTextField = UITextField()
    private let cellReuseIdentifier = "SettingTableViewCell"
    private let disposeBag = DisposeBag()
    fileprivate var dataSource: RxTableViewSectionedAnimatedDataSource<AnswersSection>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBarButtonItems()
        self.setupTableView()
        self.tapToHide()
        self.setupBindings()
        self.setupDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsViewModel.fetchAnswers()
    }

    private func setupDataSource() {
        dataSource = RxTableViewSectionedAnimatedDataSource<AnswersSection>(
            configureCell: { (_, tableView, indexPath, presentableAnswer) -> UITableViewCell in
                let cell: SettingTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.answerLabel.text = presentableAnswer.answer
                cell.timeStampLabel.text = presentableAnswer.timestamp
                return cell
        }, canEditRowAtIndexPath: { _, _ -> Bool in
            return true
        })

        settingsViewModel.answersPack.asObservable()
            .map { [AnswersSection(header: "", items: $0)]}
            .bind(to: tableView.rx.items(dataSource: dataSource!))
            .disposed(by: disposeBag)
    }

    private func setupBarButtonItems() {
        self.title = L10n.navigationTitle
        let button = UIBarButtonItem(image: Asset.plus.image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(showAlertForSavePhrase))
        self.navigationItem.rightBarButtonItem = button
    }

    private func setupTableView() {
        self.tableView.register(SettingTableViewCell.classForCoder(), forCellReuseIdentifier: cellReuseIdentifier)
        self.view.addSubview(tableView)

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
        }
    }

    private func setupBindings() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let `self` = self else { return }
            self.settingsViewModel.deleteAnswer(by: indexPath)
        }).disposed(by: disposeBag)
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
                self.settingsViewModel.answerToAdd.onNext(answer)
                self.settingsViewModel.fetchAnswers()
            }
        }

        let cancelAction = UIAlertAction(title: L10n.cancelAction, style: .destructive, handler: nil)

        alert.addAction(cancelAction)
        alert.addAction(saveAction)

        present(alert, animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

//
//  SettingsTableViewCell.swift
//  Yalantis_School
//
//  Created by Valerii on 10/13/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {

    let answerLabel = UILabel()
    let timeStampLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.setupOutlets()
        self.setupConstraints()
    }

    private func setupConstraints() {
        answerLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.contentView).offset(20)
            make.centerY.equalTo(self.contentView)
            make.width.lessThanOrEqualTo(self.contentView).multipliedBy(0.5)
        }

        timeStampLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.contentView).offset(-20)
            make.centerY.equalTo(self.contentView)
            make.width.lessThanOrEqualTo(self.contentView).multipliedBy(0.4)
        }
    }

    private func setupOutlets() {
        answerLabel.font = FontFamily.SFProDisplay.regular.font(size: 17)
        answerLabel.textColor = .black
        answerLabel.adjustsFontSizeToFitWidth = true
        answerLabel.minimumScaleFactor = 0.5
        self.contentView.addSubview(answerLabel)

        timeStampLabel.font = FontFamily.SFProDisplay.regular.font(size: 17)
        timeStampLabel.textColor = .black
        self.contentView.addSubview(timeStampLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

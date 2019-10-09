//
//  BackgroundViewController.swift
//  Yalantis_School
//
//  Created by Valerii on 8/18/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import UIKit
import SnapKit

class BackgroundViewController: UIViewController {

    let backgroundImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.image = Asset.sky.image
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        navigationController?.navigationBar.barTintColor = ColorName.navigationBarTintColor.color
        navigationItem.title = L10n.navigationTitle
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: ColorName.navigationBarTitleColor.color]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addConstraintsToBackgroundImage()
    }

    func addConstraintsToBackgroundImage() {
        backgroundImage.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
}

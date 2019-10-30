//
//  TabBarController.swift
//  Yalantis_School
//
//  Created by Valerii on 10/17/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {

    let persistenceService = PersistenceService()
    private let mainViewController = MainViewController()
    private let settingsViewController = SettingsViewController()
    private let requestService = RequestService()
    private let keyChainService = KeyChainService()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.setupTabBarController()
        self.setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTabBarController() {
        let dataFetcher = DataFetcher(requestService: requestService)
        let mainModel = MainModel(dataFetcher: dataFetcher,
                                  persistenceService: persistenceService,
                                  keyChainService: keyChainService)
        let mainViewModel = MainViewModel(mainModel: mainModel)
        mainViewController.mainViewModel = mainViewModel
        let settingsModel = SettingsModel(persistenceService: persistenceService)
        let settingsViewModel = SettingsViewModel(settingsModel: settingsModel)
        settingsViewController.settingsViewModel = settingsViewModel
        let firstTabBarVC = UINavigationController(rootViewController: mainViewController)
        firstTabBarVC.tabBarItem = UITabBarItem(
        title: L10n.ball,
        image: Asset.ball.image,
        selectedImage: Asset.ball.image)
        let seconTabBarVC = UINavigationController(rootViewController: settingsViewController)
        seconTabBarVC.tabBarItem = UITabBarItem(
        title: L10n.settings,
        image: Asset.settings.image,
        selectedImage: Asset.settings.image)
        viewControllers = [firstTabBarVC, seconTabBarVC]
    }

    private func setupAppearance() {
        UINavigationBar.appearance().barTintColor = ColorName.navigationBarTintColor.color
        UINavigationBar.appearance().titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: ColorName.navigationBarTitleColor.color
        ]
        UINavigationBar.appearance().isTranslucent = true

        UITabBar.appearance().barTintColor = ColorName.navigationBarTintColor.color
        UITabBar.appearance().tintColor = ColorName.navigationBarTitleColor.color
        UITabBar.appearance().isTranslucent = true
    }
}

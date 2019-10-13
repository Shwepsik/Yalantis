//
//  AppDelegate.swift
//  Yalantis_School
//
//  Created by Valerii on 8/18/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let persistenceService = PersistenceService()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let requestService = RequestService()
        let dataFetcher = DataFetcher(requestService: requestService)
        let keyChainService = KeyChainService()
        let mainModel = MainModel(dataFetcher: dataFetcher,
                                  persistenceService: persistenceService,
                                  keyChainService: keyChainService)
        let mainViewModel = MainViewModel(mainModel: mainModel)

        window = UIWindow(frame: UIScreen.main.bounds)

        let mainViewController = MainViewController()
        window?.rootViewController = UINavigationController(rootViewController: mainViewController)
        mainViewController.mainViewModel = mainViewModel
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        persistenceService.save()
    }
}

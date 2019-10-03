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
        let mainModel = MainModel(dataFetcher: dataFetcher, persistenceService: persistenceService)
        let mainViewModel = MainViewModel(mainModel: mainModel)

        let mainViewController = StoryboardScene.Main.mainViewController.instantiate()
        mainViewController.mainViewModel = mainViewModel

        self.window?.rootViewController = UINavigationController(rootViewController: mainViewController)

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        persistenceService.save()
    }
}

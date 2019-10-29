//
//  KeyChain.swift
//  Yalantis_School
//
//  Created by Valerii on 10/7/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

protocol SecureStorage {
    func addShakeCount()
    func getShakeCount() -> ShakeCountModel
}

class KeyChainService: SecureStorage {
    private let shakeCountKey = "shakeCount"
    private let keyChainWrapper = KeychainWrapper.standard

    func addShakeCount() {
        let getShakeCounts: Int? = keyChainWrapper.integer(forKey: shakeCountKey)
        let newShakeCounts = (getShakeCounts ?? 0) + 1
        keyChainWrapper.set(newShakeCounts, forKey: shakeCountKey)
    }

    func getShakeCount() -> ShakeCountModel {
        let getShakeCounts: Int? = keyChainWrapper.integer(forKey: shakeCountKey)
        let shakeCountModel = ShakeCountModel(shakeCount: getShakeCounts ?? 0)
        return shakeCountModel
    }
}

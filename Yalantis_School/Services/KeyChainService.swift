//
//  KeyChain.swift
//  Yalantis_School
//
//  Created by Valerii on 10/7/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

typealias ShakeCountModelResponse = (_ result: ShakeCountModel) -> Void

protocol SecureStorage {
    func addShakeCount()
    func getShakeCount(_ responseBlock: @escaping (ShakeCountModelResponse))
}

class KeyChainService: SecureStorage {

    func addShakeCount() {
        let getShakeCounts: Int? = KeychainWrapper.standard.integer(forKey: "shakeCount")
        let newShakeCounts = (getShakeCounts ?? 0) + 1
        KeychainWrapper.standard.set(newShakeCounts, forKey: "shakeCount")
    }

    func getShakeCount(_ responseBlock: @escaping (ShakeCountModelResponse)) {
        let getShakeCounts: Int? = KeychainWrapper.standard.integer(forKey: "shakeCount")
        let shakeCountModel = ShakeCountModel(shakeCount: getShakeCounts ?? 0)
        responseBlock(shakeCountModel)
    }
}

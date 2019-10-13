//
//  ShakeCountModel.swift
//  Yalantis_School
//
//  Created by Valerii on 10/8/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation

struct ShakeCountModel {

    var shakeCount: Int
}

extension ShakeCountModel {

    func toPresentableShakeCount(intenger: Int) -> PresentableShakeCount {
        return PresentableShakeCount(shakeCount: String(intenger))
    }

}

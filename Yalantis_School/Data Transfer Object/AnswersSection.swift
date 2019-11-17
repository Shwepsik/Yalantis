//
//  SectionViewModel.swift
//  Yalantis_School
//
//  Created by Valerii on 10/29/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources

struct AnswersSection {
    var header: String
    var items: [PresentableAnswer]
}

extension AnswersSection: AnimatableSectionModelType {

    typealias Identity = String

    var identity: String {
        return header
    }

    typealias Item = PresentableAnswer

    init(original: AnswersSection, items: [PresentableAnswer]) {
        self = original
        self.items = items
    }
}

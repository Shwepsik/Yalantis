//
//  ReusableTableViewCell.swift
//  Yalantis_School
//
//  Created by Valerii on 10/17/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let cellIdentifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? T ?? T()
    }
}

//
//  AlertController.swift
//  Yalantis_School
//
//  Created by Valerii on 8/18/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func showAlert(title: String, messgae: String, style: UIAlertController.Style) {

        let alert = UIAlertController(title: title, message: messgae, preferredStyle: style)
        let action = UIAlertAction(title: L10n.ok, style: .default) { (_) in
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

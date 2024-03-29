//
//  HideKeyboard.swift
//  Yalantis_School
//
//  Created by Valerii on 8/18/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    func tapToHide() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    /*
     Settings и главный контроллеры зачем-то сразу прячут клавиатуру.
     Возможно, нейминг функции ввел Вас в заблуждение
     Я просто создаю UITapGestureRecognizer в селектор которого кладу функцию , view.endEditing(true) не сработает до тех пор пока я не нажму на экран
     */
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UIViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


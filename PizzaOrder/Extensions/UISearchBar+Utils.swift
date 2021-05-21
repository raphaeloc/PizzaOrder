//
//  UISearchBar+Utils.swift
//  PizzaOrder
//
//  Created by Raphael de Oliveira Chagas on 21/05/21.
//

import UIKit

extension UISearchBar {
    
    func getTextfield() -> UITextField {
        guard let textfield = value(forKey: "searchField") as? UITextField else {
            fatalError()
        }
        
        return textfield
    }
}

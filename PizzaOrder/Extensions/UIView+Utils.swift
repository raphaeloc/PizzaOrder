//
//  UIView+Layout.swift
//  PizzaOrder
//
//  Created by Raphael de Oliveira Chagas on 20/05/21.
//

import UIKit

let kErrorDequeueCellIdenfier = "Could not dequeue cell with identifier"

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    // MARK: - Load nib
    
    static var identifier: String { return String(describing: self) }
    
    static func fromNib<T: UIView>(owner: Any? = nil) -> T {
        guard let result = Bundle.main.loadNibNamed(T.identifier, owner: owner, options: nil)?.first as? T else {
            fatalError("\(kErrorDequeueCellIdenfier): \(T.identifier)")
        }
        return result
    }
    
    static func fromNibNamed(_ name: String, owner: Any? = nil) -> UIView {
        guard let result = Bundle.main.loadNibNamed(name, owner: owner, options: nil)?.first as? UIView else {
            fatalError("\(kErrorDequeueCellIdenfier): \(name)")
        }
        return result
    }
}

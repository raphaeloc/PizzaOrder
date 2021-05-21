//
//  SpinnerView.swift
//  PizzaOrder
//
//  Created by Raphael de Oliveira Chagas on 20/05/21.
//

import UIKit

class SpinnerView: UIView {
    
    let parentView: UIView
    let spinner: UIActivityIndicatorView
    
    init(forParent parentView: UIView) {
        self.parentView = parentView
        spinner = UIActivityIndicatorView(style: .whiteLarge)
        super.init(frame: parentView.bounds)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = UIColor.darkGray.withAlphaComponent(0.25)
        spinner.color = .white
        center = parentView.center
        spinner.center = center
        addSubview(spinner)
    }
    
    func show() {
        spinner.hidesWhenStopped = true
        parentView.addSubview(self)
        spinner.startAnimating()
    }
    
    func hide() {
        removeFromSuperview()
    }
}

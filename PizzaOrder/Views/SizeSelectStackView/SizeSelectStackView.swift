//
//  SizeSelectStackView.swift
//  PizzaOrder
//
//  Created by Raphael de Oliveira Chagas on 20/05/21.
//

import UIKit

enum SizeOptions: String {
    case p = "P"
    case m = "M"
    case g = "G"
}

protocol SizeSelectStackViewDelegate: class {
    func sizeSelectStackView(_ sizeSelectStackView: SizeSelectStackView, didSelected sizeOption: SizeOptions)
}

class SizeSelectStackView: UIStackView {
    
    @IBOutlet weak var pView: SizeSelectView!
    @IBOutlet weak var mView: SizeSelectView!
    @IBOutlet weak var gView: SizeSelectView!
    
    weak var delegate: SizeSelectStackViewDelegate?

    var selected: SizeSelectView? {
        didSet {
            guard let selected = selected,
                  let option = SizeOptions(rawValue: selected.textLabel.text ?? String()) else { return }
            delegate?.sizeSelectStackView(self, didSelected: option)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pView.delegate = self
        mView.delegate = self
        gView.delegate = self
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        pView.tap()
    }
}

extension SizeSelectStackView: SizeSelectViewDelegate {
    
    func resetOptions() {
        pView.isSelected = false
        mView.isSelected = false
        gView.isSelected = false
    }
    
    func sizeSelectView(_ sizeSelectView: SizeSelectView, didChangeStatus status: Bool) {
        resetOptions()
        selected = sizeSelectView
    }
}

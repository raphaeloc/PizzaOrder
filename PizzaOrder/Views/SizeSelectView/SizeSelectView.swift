//
//  SizeSelectView.swift
//  PizzaOrder
//
//  Created by Raphael de Oliveira Chagas on 20/05/21.
//

import UIKit

protocol SizeSelectViewDelegate: class {
    func sizeSelectView(_ sizeSelectView: SizeSelectView, didChangeStatus status: Bool)
}

class SizeSelectView: UIView {
    
    @IBOutlet weak var textLabel: UILabel!
    
    weak var delegate: SizeSelectViewDelegate?
    
    var isSelected = false {
        didSet {
            changeLayout()
            guard isSelected else { return }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        gesture.cancelsTouchesInView = false
        addGestureRecognizer(gesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.allCorners], radius: 10)
    }
    
    @objc
    func tap() {
        guard !isSelected else { return }
        delegate?.sizeSelectView(self, didChangeStatus: isSelected)
        isSelected.toggle()
    }
    
    func changeLayout() {
        let backgroundColor = isSelected ? UIColor(hex: 0x7AC64F) : UIColor(hex: 0xF2F2F2)
        let textColor = isSelected ? UIColor(hex: 0xF2F2F2) : UIColor(hex: 0x282C30)
        
        self.backgroundColor = backgroundColor
        textLabel.textColor = textColor
    }
}

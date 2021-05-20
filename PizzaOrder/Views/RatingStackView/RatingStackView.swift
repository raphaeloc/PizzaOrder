//
//  RatingStackView.swift
//  PizzaOrder
//
//  Created by Raphael de Oliveira Chagas on 20/05/21.
//

import UIKit

class RatingStackView: UIStackView {
    
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!
    @IBOutlet weak var fourthStar: UIImageView!
    @IBOutlet weak var fifthStar: UIImageView!
    
    var rating = Int(0) {
        didSet {
            resetImages()
            let images = [firstStar,
                          secondStar,
                          thirdStar,
                          fourthStar,
                          fifthStar]
            
            for index in 0..<rating {
                images[index]?.image = UIImage(named: "starOn")
            }
        }
    }
    
    func resetImages() {
        firstStar.image = UIImage(named: "starOff")
        secondStar.image = UIImage(named: "starOff")
        thirdStar.image = UIImage(named: "starOff")
        fourthStar.image = UIImage(named: "starOff")
        fifthStar.image = UIImage(named: "starOff")
    }
}

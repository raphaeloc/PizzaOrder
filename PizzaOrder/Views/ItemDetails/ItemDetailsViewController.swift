//
//  ItemDetailsViewController.swift
//  PizzaOrder
//
//  Created by Raphael de Oliveira Chagas on 20/05/21.
//

import UIKit

protocol ItemDetailsViewControllerDelegate: class {
    func itemDetailsViewControllerDidTapBuyButton()
}

class ItemDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingStackView: RatingStackView!
    @IBOutlet weak var sizeSelectStackView: SizeSelectStackView!
    @IBOutlet weak var priceLabel: UILabel!
    
    let viewModel: ItemDetailsViewModel
    
    weak var delegate: ItemDetailsViewControllerDelegate?
    
    init(withItem item: Item) {
        viewModel = ItemDetailsViewModel(withItem: item)
        super.init(nibName: String(describing: ItemDetailsViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupView() {
        sizeSelectStackView.delegate = self
        
        imageView.downloaded(from: viewModel.item.imageUrl)
        imageView.contentMode = .scaleToFill
        nameLabel.text = viewModel.item.name
        ratingStackView.rating = viewModel.item.rating
        priceLabel.text = String(format: "R$ %.02f", viewModel.item.priceP).replacingOccurrences(of: ".", with: ",")
    }
    
    @IBAction func didTapBuyButton(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.itemDetailsViewControllerDidTapBuyButton()
        }
    }
}

extension ItemDetailsViewController: SizeSelectStackViewDelegate {
    
    func sizeSelectStackView(_ sizeSelectStackView: SizeSelectStackView, didSelected sizeOption: SizeOptions) {
        switch sizeOption {
        case .p:
            priceLabel.text = String(format: "R$ %.02f", viewModel.item.priceP).replacingOccurrences(of: ".", with: ",")
        case .m:
            priceLabel.text = String(format: "R$ %.02f", viewModel.item.priceM).replacingOccurrences(of: ".", with: ",")
        case .g:
            priceLabel.text = String(format: "R$ %.02f", viewModel.item.priceG).replacingOccurrences(of: ".", with: ",")
        }
    }
}

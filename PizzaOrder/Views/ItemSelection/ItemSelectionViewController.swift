//
//  OrderSelectionViewController.swift
//  PizzaOrder
//
//  Created by Raphael de Oliveira Chagas on 20/05/21.
//

import UIKit

class ItemSelectionViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel: ItemSelectionViewModel
    
    init() {
        viewModel = ItemSelectionViewModel()
        super.init(nibName: String(describing: ItemSelectionViewController.self), bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        (searchBar.value(forKey: "searchField") as? UITextField)?.backgroundColor = UIColor(hex: 0xE6E6E7)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.isUserInteractionEnabled = false
        collectionView.register(ItemCollectionViewCell.self)
        collectionView.registerHeader(TitleCollectionReusableView.self)
        
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionHeadersPinToVisibleBounds = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

extension ItemSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.item(at: indexPath.row)
        let vc = ItemDetailsViewController(withItem: item)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableHeader(of: TitleCollectionReusableView.self, for: indexPath)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.isFetching ? 8 : viewModel.numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(of: ItemCollectionViewCell.self, for: indexPath) { [unowned self] cell in
            if viewModel.isFetching {
                cell.setupForSkeleton()
            } else {
                let item = self.viewModel.item(at: indexPath.row)
                cell.setup(withItem: item)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 30
        return CGSize(width: width, height: 106)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height: CGFloat = viewModel.isFetching ? 0 : 50
        return CGSize(width: collectionView.frame.width, height: height)
    }
}

extension ItemSelectionViewController: ItemSelectionViewModelDelegate {
    
    func itemSelectionViewModelDidUpdatedItems() {
        DispatchQueue.main.async {
            self.collectionView.isScrollEnabled = true
            self.collectionView.isUserInteractionEnabled = true
            self.collectionView.reloadData()
        }
    }
}

extension ItemSelectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.didChangeText(searchText)
    }
}

extension ItemSelectionViewController: ItemDetailsViewControllerDelegate {
    
    func itemDetailsViewControllerDidTapBuyButton() {
        let vc = ConfirmationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

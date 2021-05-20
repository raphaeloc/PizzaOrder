//
//  OrderSelectionViewController.swift
//  PizzaOrder
//
//  Created by Raphael de Oliveira Chagas on 20/05/21.
//

import UIKit

class OrderSelectionViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel: OrderSelectionViewModel
    
    init() {
        viewModel = OrderSelectionViewModel()
        super.init(nibName: String(describing: OrderSelectionViewController.self), bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = UIColor(hex: 0xE6E6E7)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OrderCollectionViewCell.self)
        collectionView.registerHeader(TitleCollectionReusableView.self)
        
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionHeadersPinToVisibleBounds = true
    }
}

extension OrderSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        let cell = collectionView.dequeueReusableCell(of: OrderCollectionViewCell.self, for: indexPath) { [unowned self] cell in
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
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

extension OrderSelectionViewController: OrderSelectionViewModelDelegate {
    
    func orderSelectionViewModelDidUpdatedItems() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension OrderSelectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.didChangeText(searchBar.searchTextField)
    }
}

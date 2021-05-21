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
    var isKeyboardShow = false
    
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

        setupSearchBar()
        setupCollectionView()
        setupGesture()
        setupNotification()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(UIResponder.keyboardDidShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardDidHideNotification)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(shouldDismissKeyboard))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.isUserInteractionEnabled = false
        collectionView.register(ItemCollectionViewCell.self)
        collectionView.registerHeader(TitleCollectionReusableView.self)
        
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionHeadersPinToVisibleBounds = true
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.getTextfield().backgroundColor = UIColor(hex: 0xE6E6E7)
        searchBar.getTextfield().delegate = self
    }
    
    @objc
    func shouldDismissKeyboard() {
        searchBar.getTextfield().resignFirstResponder()
    }
    
    @objc
    func keyboardDidShow(_ notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, !isKeyboardShow else {
            (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset.bottom = 0
            return
        }
        
        isKeyboardShow = true
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        UIView.animate(withDuration: 0.25) {
            (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset.bottom = keyboardHeight + 12
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func keyboardDidHide(_ notification: Notification) {
        guard isKeyboardShow else { return }
        isKeyboardShow = false
        
        UIView.animate(withDuration: 0.25) {
            (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset.bottom = 0
            self.view.layoutIfNeeded()
        }
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

extension ItemSelectionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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

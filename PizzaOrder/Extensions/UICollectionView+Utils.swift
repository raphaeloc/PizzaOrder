//
//  UICollectionView+Utils.swift
//  Orma
//
//  Created by Raphael de Oliveira Chagas on 17/05/21.
//

import UIKit

extension UICollectionView {
    
    func register(_ cell: UICollectionViewCell.Type, bundle: Bundle? = nil) {
        let nib = UINib(nibName: cell.identifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: cell.identifier)
    }
    
    func registerHeader(_ reusableView: UICollectionReusableView.Type) {
        let nib = UINib(nibName: reusableView.identifier, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reusableView.identifier)
    }
    
    func registerFooter(_ reusableView: UICollectionReusableView.Type) {
        let nib = UINib(nibName: reusableView.identifier, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reusableView.identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(of class: T.Type,
                                                             for indexPath: IndexPath,
                                                             configure: @escaping ((T) -> Void) = { _ in }) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath)
        if let typedCell = cell as? T {
            configure(typedCell)
        }
        return cell
    }
    
    func dequeueReusableHeader<T: UICollectionReusableView>(_ view: T.Type, indexPath: IndexPath) -> T {
        let header = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.identifier,
            for: indexPath
        )
        guard let result = header as? T else {
            fatalError("\(kErrorDequeueCellIdenfier): \(T.identifier)")
        }
        return result
    }

    func dequeueReusableHeader<T: UICollectionReusableView>(of class: T.Type,
                                                            for indexPath: IndexPath,
                                                            configure: @escaping (T) -> Void = { _ in }) -> UICollectionReusableView {
        let header = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.identifier,
            for: indexPath
        )
        if let headerCell = header as? T {
            configure(headerCell)
        }
        return header
    }
    
    func dequeueReusableFooter<T: UICollectionReusableView>(of class: T.Type,
                                                            for indexPath: IndexPath,
                                                            configure: @escaping (T) -> Void = { _ in }) -> UICollectionReusableView {
        let footer = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: T.identifier,
            for: indexPath
        )
        if let footerCell = footer as? T {
            configure(footerCell)
        }
        return footer
    }

    func highlightItemAt(indexPath: IndexPath, color: UIColor? = nil, hapticFeedbackEnable: Bool = true) {
        guard let cell = self.cellForItem(at: indexPath) else { return }
        let color = color ?? UIColor.lightGray.withAlphaComponent(0.4)
        cell.backgroundColor = color
        if hapticFeedbackEnable {
            DispatchQueue.main.async {
//                UIView.startSelectionFeedback()
            }
        }
    }

    func unhighlightItemAt(indexPath: IndexPath, color: UIColor? = nil) {
        guard let cell = self.cellForItem(at: indexPath) else { return }
        cell.backgroundColor = color ?? .clear
    }
}

//
//  OrderSelectionViewModel.swift
//  PizzaOrder
//
//  Created by Raphael de Oliveira Chagas on 20/05/21.
//

import UIKit

protocol ItemSelectionViewModelDelegate: class {
    func itemSelectionViewModelDidUpdatedItems()
}

class ItemSelectionViewModel {
    
    let service: ItemSelectionService
    
    weak var delegate: ItemSelectionViewModelDelegate?
    
    var isFetching = true
    var filteredItems = Items() {
        didSet {
            delegate?.itemSelectionViewModelDidUpdatedItems()
        }
    }
    var items = Items() {
        didSet {
            filteredItems = items
        }
    }
    
    var numberOfRows: Int {
        filteredItems.count
    }
    
    init() {
        service = ItemSelectionService()
        fetchItems()
    }
    
    func didChangeText(_ sender: UISearchTextField) {
        guard let text = sender.text, !text.isEmpty else {
            filteredItems = items
            return
        }
        filteredItems = (items.filter{ $0.name.contains(text) }).sorted(by: { $1.rating < $0.rating })
    }
    
    func fetchItems() {
        service.fetchItems { [weak self] data in
            guard let decodedData = try? JSONDecoder().decode(Items.self, from: data ?? Data()) else {
                fatalError()
            }
            
            self?.isFetching = false
            self?.items = decodedData.sorted(by: { $1.rating < $0.rating })
        }
    }
    
    func item(at position: Int) -> Item {
        filteredItems[position]
    }
}

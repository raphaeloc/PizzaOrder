//
//  OrderSelectionService.swift
//  PizzaOrder
//
//  Created by Raphael de Oliveira Chagas on 20/05/21.
//

import Foundation
import Alamofire

class OrderSelectionService {
    
    let url = "https://p3teufi0k9.execute-api.us-east-1.amazonaws.com/v1/pizza"
    
    func fetchItems(completion: @escaping (Data?) -> Void) {
        
        AF.request(url, method: .get).responseJSON { response in
            completion(response.data)
        }
    }
}

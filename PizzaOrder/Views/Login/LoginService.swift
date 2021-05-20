//
//  LoginService.swift
//  PizzaOrder
//
//  Created by Raphael de Oliveira Chagas on 20/05/21.
//

import Foundation
import Alamofire

class LoginService {
    
    let url = "https://p3teufi0k9.execute-api.us-east-1.amazonaws.com/v1/signin"
    
    func doLogin(withLogin login: String, password: String, completion: @escaping (Login?) -> Void) {
        
        let parameters = [
            "email": "\(login)",
            "password": "\(password)"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            completion(try? JSONDecoder().decode(Login.self, from: response.data ?? Data()))
        }
    }
}

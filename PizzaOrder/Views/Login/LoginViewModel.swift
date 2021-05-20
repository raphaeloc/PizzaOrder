//
//  LoginViewModel.swift
//  PizzaOrder
//
//  Created by Raphael de Oliveira Chagas on 20/05/21.
//

import Foundation

class LoginViewModel {
    
    let service: LoginService
    
    init() {
        service = LoginService()
    }
    
    func doLogin(withLogin login: String, password: String, completion: @escaping (Bool) -> Void) {
        service.doLogin(withLogin: login, password: password) { login in
            completion(login?.accessToken != nil)
        }
    }
    
    func saveLogin(_ login: String) {
        let userDefaults = UserDefaults()
        userDefaults.setValue(login, forKey: Constants.Keys.loginUserDefaultsKey)
    }
}

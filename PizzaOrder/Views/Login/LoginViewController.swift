//
//  LoginViewController.swift
//  PizzaOrder
//
//  Created by Raphael de Oliveira Chagas on 20/05/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let viewModel: LoginViewModel
    
    lazy var spinnerView = SpinnerView(forParent: view)
    
    init() {
        viewModel = LoginViewModel()
        super.init(nibName: String(describing: LoginViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        userTextfield.text = UserDefaults().string(forKey: Constants.Keys.loginUserDefaultsKey)
        loginButton.layer.cornerRadius = 10
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        guard let login = userTextfield.text, let password = passwordTextfield.text else {
            let alert = UIAlertController(title: "Erro", message: "Digite o login e a senha", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        spinnerView.show()
        viewModel.doLogin(withLogin: login, password: password) { [weak self] result in
            guard result else {
                let alert = UIAlertController(title: "Erro", message: "Login ou senha inválidos, tente novamente.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self?.present(alert, animated: true, completion: nil)
                return
            }
            
            self?.viewModel.saveLogin(login)
            self?.openSelectOrder()
            self?.spinnerView.hide()
        }
    }
    
    func openSelectOrder() {
        let vc = ItemSelectionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

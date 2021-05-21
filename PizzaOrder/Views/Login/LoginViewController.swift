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
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    
    let viewModel: LoginViewModel
    
    var isKeyboardShow = false
    
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
        
        userTextfield.delegate = self
        passwordTextfield.delegate = self
        
        navigationController?.view.backgroundColor = .black
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
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
            self?.spinnerView.hide()
            guard result else {
                let alert = UIAlertController(title: "Erro", message: "Login ou senha inválidos, tente novamente.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self?.present(alert, animated: true, completion: nil)
                return
            }
            
            self?.viewModel.saveLogin(login)
            self?.openSelectOrder()
        }
    }
    
    func openSelectOrder() {
        let vc = ItemSelectionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func keyboardDidShow(_ notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, !isKeyboardShow else {
            view.frame.origin.y = 0
            return
        }
        
        isKeyboardShow = true
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        let loginButtonBottomY = loginButton.frame.origin.y + loginButton.frame.height + 12
        let distance = abs(loginButtonBottomY - view.frame.height)
        
        UIView.animate(withDuration: 0.25) {
            
            self.imageViewLeadingConstraint.constant -= 31
            self.imageViewTrailingConstraint.constant -= 31
            self.imageViewBottomConstraint.constant -= 31
            self.imageViewTopConstraint.constant -= 31
            self.topViewHeightConstraint.constant -= (keyboardHeight - distance)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func keyboardDidHide(_ notification: Notification) {
        guard isKeyboardShow else { return }
        isKeyboardShow = false
        
        UIView.animate(withDuration: 0.25) {
            self.imageViewLeadingConstraint.constant += 31
            self.imageViewTrailingConstraint.constant += 31
            self.imageViewBottomConstraint.constant += 31
            self.imageViewTopConstraint.constant += 31
            self.topViewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.returnKeyType {
        case .next:
            passwordTextfield.becomeFirstResponder()
        case .send:
            passwordTextfield.resignFirstResponder()
            didTapLoginButton(loginButton as Any)
        default:
            return false
        }
        return true
    }
}

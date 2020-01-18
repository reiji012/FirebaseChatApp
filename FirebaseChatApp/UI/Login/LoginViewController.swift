//
//  LoginViewController.swift
//  FirebaseChatApp
//
//  Created by reiji matsumura on 2020/01/18.
//  Copyright © 2020 reiji matsumura. All rights reserved.
//

import UIKit

protocol LoginViewControllerProtocol {
    func configureTextFields(email: String?)
    func presentValidateAlert()
}

class LoginViewController: UIViewController, LoginViewControllerProtocol {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var presenter: LoginViewPresenterProtocl!
    
    static func initiate() -> LoginViewController {
        let viewController = UIStoryboard.instantiateInitialViewController(from: self)
        viewController.presenter = LoginViewPresenter(view: viewController)
        return viewController
    }
    
    static func initiate(email: String) -> LoginViewController {
        let viewController = UIStoryboard.instantiateInitialViewController(from: self)
        viewController.presenter = LoginViewPresenter(view: viewController, email: email)
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureTextFields(email: String?) {
        emailTextField.delegate = self //デリゲートをセット
        passwordTextField.delegate = self //デリゲートをセット
        passwordTextField.isSecureTextEntry = true // 文字を非表示に
        
        if let email = email {
            emailTextField.text = email
        }
    }
    
    @IBAction func touchLoginButton(_ sender: Any) {
        presenter.didTouchLoginButton(email: emailTextField.text, password: passwordTextField.text)
    }
    
    func presentValidateAlert() {
        let alert = UIAlertController(title: "メール認証", message: "メール認証を行ってください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

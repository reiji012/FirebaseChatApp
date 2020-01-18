//
//  SignupViewController.swift
//  FirebaseChatApp
//
//  Created by reiji matsumura on 2020/01/18.
//  Copyright © 2020 reiji matsumura. All rights reserved.
//

import UIKit

protocol SignupViewControllerProtocol {
    func configureTextFields()
    func showError(errorMessage: String)
}

class SignupViewController: UIViewController, SignupViewControllerProtocol {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var presenter: SignupViewPresenterProtocl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SignupViewPresenter(view: self)
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    func configureTextFields() {
        emailTextField.delegate = self //デリゲートをセット
        passwordTextField.delegate = self //デリゲートをセット
        passwordTextField.isSecureTextEntry = true // 文字を非表示に
    }
    
    @IBAction func touchSignupButton(_ sender: Any) {
        presenter.didTouchSignupButton(email: emailTextField.text, password: passwordTextField.text)
    }
    
    @IBAction func touchLoginButton(_ sender: Any) {
        presenter.didTouchLoginButton()
    }
    
    func showError(errorMessage: String) {
        let alert = UIAlertController(title: "サインアップに失敗しました", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SignupViewController: UITextFieldDelegate {
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

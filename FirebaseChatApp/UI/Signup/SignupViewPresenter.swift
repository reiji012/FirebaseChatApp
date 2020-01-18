//
//  SignupViewPresenter.swift
//  FirebaseChatApp
//
//  Created by reiji matsumura on 2020/01/18.
//  Copyright © 2020 reiji matsumura. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol SignupViewPresenterProtocl {
    func viewDidLoad()
    func viewWillAppear()
    func didTouchSignupButton(email: String?, password: String?)
    func didTouchLoginButton()
}

class SignupViewPresenter: SignupViewPresenterProtocl {
    
    var view: SignupViewControllerProtocol
    
    init(view: SignupViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view.configureTextFields()
    }
    
    func viewWillAppear() {
        if self.checkUserVerify() {
            self.pushListView()
        }
    }
    
    func didTouchSignupButton(email: String?, password: String?) {
        //emailTextFieldとpasswordTextFieldに文字がなければ、その後の処理をしない
        guard let email = email else  { return }
        guard let password = password else { return }
        //FIRAuth.auth()?.createUserWithEmailでサインアップ
        //第一引数にEmail、第二引数にパスワード
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            //エラーなしなら、認証完了
            if error == nil{
                // エラーがない場合にはそのままログイン画面に飛び、ログインしてもらう
                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                    if error == nil {
                        // エラーがない場合にはそのままログイン画面に飛び、ログインしてもらう
                        self.pushLoginView(email: email)
                    }else {
                        self.view.showError(errorMessage: "\(error?.localizedDescription)")
                    }
                })
            } else {
                self.view.showError(errorMessage: "\(error?.localizedDescription)")
            }
        })
    }
    
    func didTouchLoginButton() {
        pushLoginView()
    }
    
    private func pushLoginView(email: String? = nil) {
        guard let view = self.view as? SignupViewController else {
            return
        }
        let loginView = email == nil ? LoginViewController.initiate() :  LoginViewController.initiate(email: email!)
        view.navigationController?.pushViewController(loginView, animated: true)
    }
    
    private func pushListView() {
        guard let view = self.view as? SignupViewController else {
            return
        }
        let listView = ListViewController.initiate()
        view.navigationController?.pushViewController(listView, animated: true)
    }
    
    // ログイン済みかどうかと、メールのバリデーションが完了しているか確認
    private func checkUserVerify()  -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
        return user.isEmailVerified
    }
}

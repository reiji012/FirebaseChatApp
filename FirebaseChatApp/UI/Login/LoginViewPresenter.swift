//
//  LoginViewPresenter.swift
//  FirebaseChatApp
//
//  Created by reiji matsumura on 2020/01/18.
//  Copyright © 2020 reiji matsumura. All rights reserved.
//

import Foundation
import Firebase

protocol LoginViewPresenterProtocl {
    func viewDidLoad()
    func didTouchLoginButton(email: String?, password: String?)
}

class LoginViewPresenter: LoginViewPresenterProtocl {
    
    var view: LoginViewControllerProtocol
    var email: String?
    
    init(view: LoginViewControllerProtocol, email: String? = nil) {
        self.view = view
        self.email = email
    }
    
    func viewDidLoad() {
        view.configureTextFields(email: email)
    }
    
    func didTouchLoginButton(email: String?, password: String?) {
        //EmailとPasswordのTextFieldに文字がなければ、その後の処理をしない
        guard let email = email else { return }
        guard let password = password else { return }

        //signInWithEmailでログイン
        //第一引数にEmail、第二引数にパスワードを取ります
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            //エラーがないことを確認
            if error == nil {
                if let loginUser = user {
                   // バリデーションが完了しているか確認。完了ならそのままログイン
                    if self.checkUserValidate(user: loginUser.user) {
                       // 完了済みなら、ListViewControllerに遷移
                        print(Auth.auth().currentUser as Any)
                       self.pushListView()
                   }else {
                       // 完了していない場合は、アラートを表示
                        self.view.presentValidateAlert()
                   }
               }
            }else {
                print("error...\(error?.localizedDescription)")
            }
        })
    }
    
    // ログインした際に、バリデーションが完了しているか返す
    private func checkUserValidate(user: User)  -> Bool {
        return user.isEmailVerified
    }
    
    private func pushListView() {
        guard let view = self.view as? LoginViewController else {
            return
        }
        let listView = ListViewController.initiate()
        view.navigationController?.pushViewController(listView, animated: true)
    }
}

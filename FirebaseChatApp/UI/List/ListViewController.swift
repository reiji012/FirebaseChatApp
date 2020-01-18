//
//  ListViewController.swift
//  FirebaseChatApp
//
//  Created by reiji matsumura on 2020/01/18.
//  Copyright © 2020 reiji matsumura. All rights reserved.
//

import UIKit
import Firebase

protocol ListViewControllerProtocol {
    func resetTextFieldText()
    func reloadList()
}

class ListViewController: UIViewController, ListViewControllerProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var textField: UITextField!
    
    var presenter: ListViewPresenterProtocol!
    
    static func initiate() -> ListViewController {
        let viewController = UIStoryboard.instantiateInitialViewController(from: self)
        viewController.presenter = ListViewPresenter(view: viewController)
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        presenter.viewDidLoad()
    }
    
    @IBAction func touchPostButton(_ sender: Any) {
        presenter.didTouchPostButton(text: textField.text)
    }
    
    func resetTextFieldText() {
        textField.text = ""
    }
    
    func reloadList() {
        tableView.reloadData()
    }
}

extension ListViewController: UITextFieldDelegate {
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ListViewController: UITableViewDelegate {
    
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.rowOfNumber()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListTableViewCell
        let content = presenter.contents(indexPath: indexPath)
        cell.idTextLabel.text = content.userId
        cell.contentTextLabel.text = content.contentString
        cell.dateTextLabel.text = content.dateString
        return cell
    }
    
    
}

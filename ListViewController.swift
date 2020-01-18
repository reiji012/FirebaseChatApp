//
//  ListViewController.swift
//  FirebaseChatApp
//
//  Created by reiji matsumura on 2020/01/18.
//  Copyright © 2020 reiji matsumura. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    static func initiate() -> ListViewController {
        let viewController = UIStoryboard.instantiateInitialViewController(from: self)
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

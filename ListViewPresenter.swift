//
//  ListViewPresenter.swift
//  FirebaseChatApp
//
//  Created by reiji matsumura on 2020/01/18.
//  Copyright © 2020 reiji matsumura. All rights reserved.
//

import Foundation
import Firebase

protocol ListViewPresenterProtocol {
    func rowOfNumber() -> Int
    func viewDidLoad()
    func didTouchPostButton(text: String?)
    func contents(indexPath: IndexPath) -> (userId: String, contentString:String, dateString: String)
}

class ListViewPresenter: ListViewPresenterProtocol {
    
    var view: ListViewControllerProtocol
    let ref = Database.database().reference() //FirebaseDatabaseのルートを指定
    var contentArray: [DataSnapshot] = [] //Fetchしたデータを入れておく配列、この配列をTableViewで表示
    var contents: [ListModel] = []
    var snap: DataSnapshot!
    
    init(view: ListViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        self.read()
    }
    
    func contents(indexPath: IndexPath) -> (userId: String, contentString:String, dateString: String) {
        //配列の該当のデータをitemという定数に代入
        let item = contents[indexPath.row]
        var contents: (userId: String, contentString:String, dateString: String)
        //contentという添字で保存していた投稿内容を表示
        contents.userId = item.userId
        contents.contentString = item.content
        //dateという添字で保存していた投稿時間をtimeという定数に代入
        let time = NumberFormatter().number(from: item.time)!.doubleValue
        //getDate関数を使って、時間をtimestampから年月日に変換して表示
        contents.dateString = self.getDate(number: time/1000)
        
        return contents
    }
    
    func rowOfNumber() -> Int {
        return contentArray.count
    }
    
    func didTouchPostButton(text: String?) {
        //textFieldになにも書かれてない場合は、その後の処理をしない
        guard let text = text else { return }

        //ロートからログインしているユーザーのIDをchildにしてデータを作成
        //childByAutoId()でユーザーIDの下に、IDを自動生成してその中にデータを入れる
        //setValueでデータを送信する。第一引数に送信したいデータを辞書型で入れる
        //今回は記入内容と一緒にユーザーIDと時間を入れる
        //FIRServerValue.timestamp()で現在時間を取る
        (self.ref.child((Auth.auth().currentUser?.uid)!) as AnyObject).childByAutoId().setValue(["user": (Auth.auth().currentUser?.uid)!,"content": text, "date": ServerValue.timestamp()])
        view.resetTextFieldText()
    }
    
    func read()  {
        //FIRDataEventTypeを.Valueにすることにより、なにかしらの変化があった時に、実行
        //今回は、childでユーザーIDを指定することで、ユーザーが投稿したデータの一つ上のchildまで指定することになる
        ref.observe(.value, with: {(snapShots) in
            if snapShots.children.allObjects is [DataSnapshot] {
                print("snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント

                print("snapShot...\(snapShots)") //読み込んだデータをプリント

                self.snap = snapShots

            }
            self.reload(snap: self.snap)
        })
    }
    
    //読み込んだデータは最初すべてのデータが一つにまとまっているので、それらを分割して、配列に入れる
    func reload(snap: DataSnapshot) {
        if snap.exists() {
            print(snap)
            //FIRDataSnapshotが存在するか確認
            contentArray.removeAll()
            contents.removeAll()
            //1つになっているFIRDataSnapshotを分割し、配列に入れる
            for item in snap.children {
                let current = item as! DataSnapshot
                for tmp in current.children {
                    contentArray.append(tmp as! DataSnapshot)
                }
            }
            
            for item in contentArray {
                var listModel = ListModel()
                //itemの中身を辞書型に変換
                let content = item.value as! Dictionary<String, AnyObject>
                //contentという添字で保存していた投稿内容を表示
                listModel.userId = String(describing: content["user"]!)
                listModel.content = String(describing: content["content"]!)
                listModel.time = String(describing: content["date"]!)
                self.contents.append(listModel)
            }
            
            self.contents.sort(by: {
                $0.time < $1.time
            })
            
            // ローカルのデータベースを更新
            ref.child((Auth.auth().currentUser?.uid)!).keepSynced(true)
            //テーブルビューをリロード
            view.reloadList()
        }
    }
    
    //timestampで保存されている投稿時間を年月日に表示形式を変換する
    func getDate(number: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: number)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }
}

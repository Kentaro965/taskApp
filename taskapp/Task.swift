//
//  Task.swift
//  taskapp
//
//  Created by ShibayamaKentaro on 2020/02/01.
//  Copyright © 2020 ShibayamaKentaro. All rights reserved.
//

import RealmSwift

class Task: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0

    // タイトル
    @objc dynamic var title = ""

    // 内容
    @objc dynamic var contents = ""

    // 日時
    @objc dynamic var date = Date()
    
    //カテゴリー
    @objc dynamic var category=""

    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}

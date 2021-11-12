//
//  MemoData.swift
//  SeSac_Memo
//
//  Created by 노건호 on 2021/11/09.
//

import Foundation
import RealmSwift

class Memo: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var title: String // 타이틀은 무조건 값이 들어가야함(나중에 뒤로 못가게하면됨)
    @Persisted var content: String? // 내용은 없을 수 있으니 옵셔널
    @Persisted var mark: Bool // 처음에는 무조건 false 넣어줌
    @Persisted var date: Date
    
    convenience init(title: String, content: String?) {
        self.init()

        self.title = title
        self.content = content ?? nil
        self.mark = false
        self.date = Date()  // 입력한 날짜로 저장
    }
}

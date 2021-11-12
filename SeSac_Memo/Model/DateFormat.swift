//
//  DateFormat.swift
//  SeSac_Memo
//
//  Created by 노건호 on 2021/11/12.
//

import Foundation

enum DateFormat: Int {
    case day
    case week
    case others
    
    func getDateFormat() -> String {
        switch self {
        case .day:
            return "a h:mm" // a는 오전 오후를 나타냄, 한국식으로 바꾸면 나타남
        case .week:
            return "EEEE" // 일요일, 화요일 처럼 표현
        case .others:
            return "YYYY. MM. dd a h:mm"
        }
    }
}

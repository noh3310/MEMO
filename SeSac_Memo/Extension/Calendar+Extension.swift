//
//  Calendar+Extension.swift
//  SeSac_Memo
//
//  Created by 노건호 on 2021/11/12.
//

import Foundation

extension Calendar {
    
    // Calendar.current.isDateInWeekend(date)가 적용이 안되서 만듬....
    func isDateInThisWeek(_ date: Date) -> Bool {
        return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
    }
}

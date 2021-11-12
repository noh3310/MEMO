//
//  Date+Extension.swift
//  SeSac_Memo
//
//  Created by 노건호 on 2021/11/11.
//

import Foundation

extension Date {
    
    // 날짜 형식 맞게 리턴해줌
    func getStringFormat(date: Date, format: DateFormat) -> String {
        
        let dateFormatter = DateFormatter()
        // 데이터 타입으로 변환
        dateFormatter.dateFormat = format.getDateFormat()
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국 타입에 맞게 변경
        
        return dateFormatter.string(from: date)
    }
    
    // 데이터 포맷 가져옴
    func getDateFormat(date: Date) -> DateFormat {
        // 만약 오늘이라면 그냥 시간만 출력해줌
        if Calendar.current.isDateInToday(date) {
            print("\(date) 는 오늘")
            return .day
        }
        // 이번주라면 이번주 요일만 출력
        else if Calendar.current.isDateInThisWeek(date) {
            print("\(date) 는 이번주")
            return .week
        }
        
        print("\(date) 는 지난주")
        return .others
    }
}

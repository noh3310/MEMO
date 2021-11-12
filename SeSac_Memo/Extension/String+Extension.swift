//
//  String+Extension.swift
//  SeSac_Memo
//
//  Created by 노건호 on 2021/11/11.
//

import UIKit

extension String {
    // 검색한 데이터가 있다면 검색에 맞는 글자만 주황색으로 설정해서 리턴해줌
    func searchData(text: String, searchText: String, defaultValue: String) -> NSMutableAttributedString {
        
        // 텍스트가 없으면
        if text == "" {
            return NSMutableAttributedString(string: defaultValue)
        }
        
        // 속성 설정
        let attributeString = NSMutableAttributedString(string: text)
        
        // 검색하는 부분만 바꿔줌
        attributeString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: (text as NSString).range(of: searchText))
        
        return attributeString
    }
    
    // 메모 타이틀, 콘텐츠 나눠서 배열 리턴
    func devideMemo(text: String) -> [String] {
        // 첫번째 인덱스를 가져옴
        let index = text.firstIndex(of: "\n") ?? text.endIndex
        
        // 타이틀 자르기
        let title = String(text[..<index])

        // 내용 뽑기(이때 \n이 포함되어있음)
        var content = String(text[index...])
        
        // 줄바꿈 없애줌
        if content.first == "\n" {
            let index = content.index(content.startIndex, offsetBy: 1)
            
            content = String(content[index...])
        }
        
        return [title, content]
    }
    
    // \n이랑 공백 없애줌
    func getRemoveString(_ string: String?) -> String? {
        if let string = string {
            var removeString = string.replacingOccurrences(of: "\n", with: "")
            removeString = removeString.replacingOccurrences(of: " ", with: "")
            
            return removeString
        }
        
        return nil
    }
}

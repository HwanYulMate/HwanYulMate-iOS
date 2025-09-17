//
//  String+Extension.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/13/25.
//

import Foundation

extension String {
    func toFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        let date = formatter.date(from: self)
        formatter.dateFormat = "yy.MM.dd"
        
        if let date {
            return formatter.string(from: date)
        } else {
            return "서버 오류"
        }
    }
}

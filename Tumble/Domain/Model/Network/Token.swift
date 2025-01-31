//
//  Token.swift
//  Tumble
//
//  Created by Adis Veletanlic on 2023-02-17.
//

import Foundation

struct Token: Codable {
    let value: String
    let createdDate: Date
    
    func isExpired() -> Bool {
        let currentDate = Date()
        return createdDate.addingTimeInterval(1314900000) <= currentDate
    }
}

enum TokenType: String {
    case refreshToken = "refresh-token"
    case sessionToken = "session-token"
}

//
//  ApiErrorModel.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 05/06/2023.
//

import Foundation

// MARK: - ErrorModel
struct ErrorModel: Codable {
    let success: Bool
    let error: ErrorData
}

// MARK: - Error
struct ErrorData: Codable {
    let code: Int
    let type, info: String
}

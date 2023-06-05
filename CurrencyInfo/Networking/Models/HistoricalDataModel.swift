//
//  HistoricalDataModel.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 04/06/2023.
//

import Foundation

// MARK: - HistoricalDataModel
struct HistoricalDataModel: Codable, Equatable {
    static func == (lhs: HistoricalDataModel, rhs: HistoricalDataModel) -> Bool {
        lhs.timestamp == rhs.timestamp
    }
    

    let success: Bool
    let timestamp: Int?
    let historical: Bool?
    let base: String?
    let date: String?
    let rates: [String: Double]?
    
    let errorModel: ErrorModel?

}

//
//  HistoricalDataModel.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 04/06/2023.
//

import Foundation

// MARK: - HistoricalDataModel
struct HistoricalDataModel: Codable, Equatable {
    let success: Bool
    let timestamp: Int?
    let historical: Bool?
    let base, date: String
    let rates: [String: Double]
}

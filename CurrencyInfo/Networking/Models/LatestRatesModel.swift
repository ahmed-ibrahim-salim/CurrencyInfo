//
//  NetworkModels.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 31/05/2023.
//

import Foundation

struct LatestRatesModel: Codable {
    let success: Bool
    let timestamp: Int
    let base, date: String
    let rates: [String: Double]
}

struct CurrencyRate: Equatable {
    let iso: String
    let rate: Double
}

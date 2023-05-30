//
//  AvailableCurrenciesModel.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 31/05/2023.
//

import Foundation

// MARK: - AvailableCurrenciesModel
struct AvailableCurrenciesModel: Codable {
    let success: Bool
    let symbols: [Currency.RawValue: String]
}

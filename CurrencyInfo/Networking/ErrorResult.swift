//
//  Errors.swift
//  CurrencyInfo
//
//  Created by Ahmed medo on 31/05/2023.
//

import Foundation

enum ErrorResult: Error, Equatable, Codable {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)

    var localizedDescription: String {
        switch self {
        case .network(let value):   return value
        case .parser(let value):    return value
        case .custom(let value):    return value
        }
    }
}

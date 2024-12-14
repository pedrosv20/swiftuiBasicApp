//
//  Asset.swift
//  AssetsLiveCoding

import Foundation

struct Asset: Decodable, Identifiable, Equatable {
    let id: String
    let name: String
    let symbol: String
    let usdPrice: String?
    let changePercent: String?
    var usdPriceConverted: String? {
        return Asset.format(usdPrice)
        
    }
    var changePercentConverted: String? {
        return Asset.format(changePercent)
    }
    
    var image: URL? {
        return .init(string: "https://raw.githubusercontent.com/trustwallet/assets/ca6ec3e5deafdcc3ac62741013522a93568cf976/blockchains/\(name.lowercased())/info/logo.png")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case changePercent = "changePercent24Hr"
        case usdPrice = "priceUsd"
    }
    
    static func format(_ value: String?) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        
        guard let value = value, let doubleValue = Double(value) else {
            return nil
        }
        
        let number = NSNumber(value: doubleValue)
        
        // Return the formatted string instead of converting back to Double
        return formatter.string(from: number)
    }
}

#if DEBUG
extension Asset {
    static func fixture(
        id: String = UUID().uuidString,
        name: String,
        symbol: String,
        usdPrice: String = "1000",
        changePercent: String = "0.5"
    ) -> Self {
        .init(id: id, name: name, symbol: symbol, usdPrice: usdPrice, changePercent: changePercent)
    }
}
#endif

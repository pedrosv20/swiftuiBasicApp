//
//  AssetsResponse.swift
//  AssetsLiveCoding

import Foundation

struct AssetsResponse: Decodable, Equatable {
    let data: [Asset]
}

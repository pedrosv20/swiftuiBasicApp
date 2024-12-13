//
//  ListModel.swift
//  PersonalProject
//
//  Created by Pedro Vargas on 13/12/24.
//

import Foundation


struct ListModel {
    let data: [PersonData]
}

struct PersonData: Identifiable {
    let id: UUID
    let title: String
    let name: String
    let isFavorite: Bool
}

extension PersonData {
    static func fixture(title: String = "", name: String = "") -> Self {
        self.init(
            id: .init(),
            title: "\(title)",
            name: "\(name)",
            isFavorite: false
        )
    }
}

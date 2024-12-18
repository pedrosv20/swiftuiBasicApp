//
//  AssetsLiveCodingApp.swift
//  AssetsLiveCoding

import SwiftUI

@main
struct AssetsLiveCodingApp: App {
    
    init() {
        DIContainer.register(AssetsService() as AssetsServiceProtocol)
    }
    var body: some Scene {
        WindowGroup {
            AssetsListView(viewModel: AssetsListViewModel(service: DIContainer.resolve(AssetsServiceProtocol.self)))
        }
    }
}

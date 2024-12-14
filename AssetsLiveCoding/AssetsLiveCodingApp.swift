//
//  AssetsLiveCodingApp.swift
//  AssetsLiveCoding

import SwiftUI

@main
struct AssetsLiveCodingApp: App {
    var body: some Scene {
        WindowGroup {
            AssetsListView(viewModel: AssetsListViewModel(service: AssetsService()))
        }
    }
}

import SnapshotTesting
import XCTest
import SwiftUI

@testable import AssetsLiveCoding

final class AssetsLiveCodingSnapshotTests: XCTestCase {
    @MainActor func test_loadDataIsCalled_itShouldLoadData() async throws {
        // Given
        let serviceMock = AssetsServiceMock()
        serviceMock.modelToBeReturned = .init(data: [
            .fixture(name: "BTC", symbol: "Bitcoin"),
            .fixture(name: "SOL", symbol: "Solana"),
            .fixture(name: "ETH", symbol: "ethereum"),
        ])
        let viewModel = AssetsListViewModel(service: serviceMock)
        let view = AssetsListView(viewModel: viewModel)
        // When
        viewModel.loadData()
        try await Task.sleep(nanoseconds: 3_000_000_000)
        
        // Then
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)), record: false)
    }
    
    @MainActor func test_toggleLike_itShouldLikeTheAsset() async throws {
        // Given
        let serviceMock = AssetsServiceMock()
        let btcAsset =  Asset.fixture(id: UUID().uuidString, name: "BTC", symbol: "Bitcoin")
        let solAsset =  Asset.fixture(id: UUID().uuidString, name: "Sol", symbol: "solana")
        serviceMock.modelToBeReturned = .init(data: [
            btcAsset,
            solAsset,
            .fixture(name: "ETH", symbol: "ethereum"),
        ])
        let viewModel = AssetsListViewModel(service: serviceMock)
        let view = AssetsListView(viewModel: viewModel)
        // When
        viewModel.loadData()
        try await Task.sleep(nanoseconds: 3_000_000_000)
        viewModel.toggleLike(for: btcAsset)
        viewModel.toggleLike(for: btcAsset)
        viewModel.toggleLike(for: solAsset)
        
        // Then
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)), record: false)
    }
    
    @MainActor func test_errorView_() async throws {
        // Given
        let serviceMock = AssetsServiceMock()
        serviceMock.modelToBeReturned = nil
        let viewModel = AssetsListViewModel(service: serviceMock)
        let view = AssetsListView(viewModel: viewModel)
        // When
        viewModel.loadData()
        try await Task.sleep(nanoseconds: 3_000_000_000)
        
        // Then
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)), record: false)
    }
    
    @MainActor func test_loadingView() async throws {
        // Given
        let serviceMock = AssetsServiceMock()
        serviceMock.modelToBeReturned = nil
        let viewModel = AssetsListViewModel(service: serviceMock)
        let view = AssetsListView(viewModel: viewModel)
        // When
        viewModel.loadData()
        try await Task.sleep(nanoseconds: 0_500_000_000)
        
        // Then
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)), record: false)
    }
    
    
}

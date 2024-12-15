//
//  AssetsLiveCodingTests.swift
//  AssetsLiveCodingTests

import XCTest
@testable import AssetsLiveCoding

final class AssetsLiveCodingTests: XCTestCase {

    @MainActor func test_loadDataIsCalled_itShouldLoadData() async throws {
        // Given
        let serviceMock = AssetsServiceMock()
        let modelToBeReturned = AssetsResponse(data: [
            .fixture(name: "Bitcoin", symbol: "BTC"),
            .fixture(name: "ETH", symbol: "ethereum"),
            .fixture(name: "SOL", symbol: "solara")
        ])
        serviceMock.modelToBeReturned = modelToBeReturned
        let expectation = expectation(description: "Wait for load data")
        let sut = AssetsListViewModel(service: serviceMock)
        // When
        sut.loadData()
        try await Task.sleep(nanoseconds: 2_000_000_000)
        // Then
        expectation.fulfill()
        XCTAssertNotNil(sut.model)
        XCTAssertEqual(sut.model, modelToBeReturned)
        XCTAssertEqual(sut.cachedModel, modelToBeReturned)
        await fulfillment(of: [expectation], timeout: 4)
    }
    
    @MainActor func test_searchBarText_whenTextIsAdded_itShouldReturnModelFiltered() async throws {
        // Given
        let serviceMock = AssetsServiceMock()
        let modelToBeReturned = AssetsResponse(data: [
            .fixture(name: "Bitcoin", symbol: "BTC"),
            .fixture(name: "ETH", symbol: "ethereum"),
            .fixture(name: "SOL", symbol: "solara")
        ])
        let filteredModel = AssetsResponse(data: [
            .fixture(name: "Bitcoin", symbol: "BTC")
        ])
        let expectation = expectation(description: "Wait for load data")
        serviceMock.modelToBeReturned = modelToBeReturned
        let sut = AssetsListViewModel(service: serviceMock)
        
        // When
        sut.loadData()
        serviceMock.modelToBeReturned = filteredModel
        sut.addTextPublisher()
        
        sut.searchText = "BTC"
        try await Task.sleep(nanoseconds: 4_000_000_000)
        // Then
        expectation.fulfill()
        XCTAssertNotNil(sut.model)
        XCTAssertEqual(sut.model, filteredModel)
        await fulfillment(of: [expectation], timeout: 4)
    }
    
    @MainActor func test_searchBarText_whenTextIsRemoved_itShouldReturnCachedData() async throws {
        // Given
        let serviceMock = AssetsServiceMock()
        let modelToBeReturned = AssetsResponse(data: [
            .fixture(name: "Bitcoin", symbol: "BTC"),
            .fixture(name: "ETH", symbol: "ethereum"),
            .fixture(name: "SOL", symbol: "solara")
        ])
        let expectation = expectation(description: "Wait for load data")
        serviceMock.modelToBeReturned = modelToBeReturned
        let sut = AssetsListViewModel(service: serviceMock)
        
        // When
        sut.loadData()
        sut.addTextPublisher()
        
        sut.searchText = ""
        try await Task.sleep(nanoseconds: 4_000_000_000)
        // Then
        expectation.fulfill()
        XCTAssertNotNil(sut.model)
        XCTAssertEqual(sut.model, sut.cachedModel)
        await fulfillment(of: [expectation], timeout: 4)
    }
    
    @MainActor func test_toggleLike_whenAssetIsNotLiked_itShouldLikeTheAsset() async throws {
        // Given
        let serviceMock = AssetsServiceMock()
        let id = UUID().uuidString
        let asset = Asset.fixture(id: id, name: "Bitcoin", symbol: "BTC")
        let modelToBeReturned = AssetsResponse(data: [
            asset,
            .fixture(name: "ETH", symbol: "ethereum"),
            .fixture(name: "SOL", symbol: "solara")
        ])
        let expectation = expectation(description: "Wait for load data")
        serviceMock.modelToBeReturned = modelToBeReturned
        let sut = AssetsListViewModel(service: serviceMock)
        
        // When
        sut.loadData()
        
        
        sut.toggleLike(for: asset)
        try await Task.sleep(nanoseconds: 2_000_000_000)
        // Then
        expectation.fulfill()
        XCTAssertNotNil(sut.model)
        XCTAssertTrue(sut.likedAssets.contains(asset.id))
        await fulfillment(of: [expectation], timeout: 2)
    }
}

//
//  AssetsListViewModel.swift
//  AssetsLiveCoding

import Foundation
import Combine

@MainActor
final class AssetsListViewModel: ObservableObject {
    private let service: AssetsServiceProtocol
    
    @Published var model: AssetsResponse?
    @Published var error: Error?
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var likedAssets: Set<String> = []
    @Published var showLikedScreen = false
    
    var cancellable: AnyCancellable?
    var dispatchQueue: DispatchQueue
    
    var cachedModel: AssetsResponse?
    
    init(service: AssetsServiceProtocol, dispatchQueue: DispatchQueue = DispatchQueue.main) {
        self.service = service
        self.dispatchQueue = dispatchQueue
    }
    
    func addTextPublisher() {
        cancellable = $searchText
            .debounce(for: 1, scheduler: dispatchQueue)
            .sink(receiveValue: { [weak self] text in
                guard let self = self else { return }
                if text != ""  {
                    self.searchFromAsset(text)
                } else {
                    model = cachedModel
                }
            })
    }
    
    func loadData() {
        cachedModel = nil
        makeRequest(asset: nil)
    }
    
    private func makeRequest(asset: String?) {
        Task {
            do {
                isLoading = true
                let response = try await  service.getAssets(by: asset)
                if response.data.count > 0 {
                    model = response
                }
                
                if asset == nil, cachedModel == nil {
                    cachedModel = response
                }
                
                isLoading = false
                error = nil
                
            } catch {
                isLoading = false
                print(error)
                self.error = error
            }
        }
    }
    
    func searchFromAsset(_ asset: String) {
        makeRequest(asset: asset)
    }
    
    func toggleLike(for asset: Asset) {
        if likedAssets.contains(asset.id) {
            likedAssets.remove(asset.id)
        } else {
            likedAssets.insert(asset.id)
        }
        
        if likedAssets.count == 0 {
            showLikedScreen = false
        }
    }

    /// 1. Fetch assets from API
    /// 2. Fetch assets by a giving term, adding some debounce for the text input
    /// 3. Add/Remove from favorites
}

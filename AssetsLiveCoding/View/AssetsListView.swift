//
//  ContentView.swift
//  AssetsLiveCoding

import SwiftUI

struct AssetsListView: View {
    @ObservedObject var viewModel: AssetsListViewModel

    var body: some View {
        NavigationView {
            VStack {
                if let error = viewModel.error {
                    errorView(error)
                }  else if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else if let model = viewModel.model {
                    listView(model)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    NavigationLink(
                        isActive: $viewModel.showLikedScreen,
                        destination: {
                            if let model = viewModel.model {
                                likedView(.init(data: model.data.filter { viewModel.likedAssets.contains($0.id)}))
                            }
                        },
                        label: { Text("Go To liked screen") }
                    )
                    .opacity(viewModel.likedAssets.count > 0 ? 1 : 0)
                })
            }
            .searchable(text: $viewModel.searchText, prompt: "Search asset")
        }
        .onAppear {
            viewModel.addTextPublisher()
            viewModel.loadData()
        }
    }
    
    func likedView(_ model: AssetsResponse) -> some View {
        listView(model)
    }
    
    func listView(_ model: AssetsResponse) -> some View {
        List(model.data) { asset in
            HStack {
                assetView(asset)
                Spacer()
                Image(systemName: viewModel.likedAssets.contains(asset.id) ? "heart.fill" : "heart")
                    .foregroundStyle(.blue)
                    .onTapGesture {
                    viewModel.toggleLike(for: asset)
                }
            }
        }
    }
    
    func assetView(_ asset: Asset) -> some View {
        Group {
            if let image = asset.image {
                asyncImage(image)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(asset.symbol)
                    Text(asset.name)
                }
                HStack {
                    if let usdPrice = asset.usdPriceConverted {
                        Text(usdPrice)
                    }
                    if let changePercent = asset.changePercentConverted {
                        Text(changePercent)
                    }
                }
            }
        }
    }
    
    func asyncImage(_ url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            case .failure:
                Circle()
                    .foregroundStyle(.gray)
                    .frame(width: 50, height: 50)
            @unknown default:
                EmptyView() // Handle any future unknown cases
            }
        }
    }
    
    func errorView(_ error: Error) -> some View {
        VStack {
            Text("Data could not be loaded")
            Text(error.localizedDescription)
            Button(action: { viewModel.loadData() }, label: { Text("Retry")}
            )
        }
    }
}

#Preview {
    AssetsListView(
        viewModel: AssetsListViewModel(
            service: AssetsService()
        )
    )
}

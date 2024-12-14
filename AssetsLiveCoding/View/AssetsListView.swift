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
                    .foregroundStyle(DS.AppColor.blue)
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
                        .fontWeight(DS.Fonts.Weight.bold)
                    Text(asset.name)
                        .foregroundStyle(DS.AppColor.gray)
                        .padding(DS.Spacing.s)
                        .background(
                            RoundedRectangle(cornerRadius: DS.CornerRadius.s)
                                .fill(DS.AppColor.gray.opacity(0.1))
                        )
                }
                HStack {
                    if let usdPrice = asset.usdPriceConverted {
                        Text("\(usdPrice)$")
                            .foregroundStyle(DS.AppColor.gray)
                            .fontWeight(DS.Fonts.Weight.bold)
                    }
                    if let changePercent = asset.changePercentConverted {
                        changePercentView(changePercent)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func changePercentView(_ changePercent: String) -> some View {
        if let doubleChangePercent = Double(changePercent.replacingOccurrences(of: ",", with: ".")) {
            Text(
                doubleChangePercent > 0
                ? "+\(changePercent)"
                : changePercent
            )
                .if(doubleChangePercent > 0, transform: {
                    $0.foregroundStyle(DS.AppColor.green)
                },
                elseIfCondition: doubleChangePercent == 0,
                elseIfTransform: {
                    $0.foregroundStyle(DS.AppColor.gray)
                }, elseTransform: {
                    $0.foregroundStyle(DS.AppColor.red)
                })
                .fontWeight(DS.Fonts.Weight.bold)
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
                    .frame(width: DS.Frame.width, height: DS.Frame.height)
                    .clipShape(Circle())
            case .failure:
                Circle()
                    .foregroundStyle(DS.AppColor.gray)
                    .frame(width: DS.Frame.width, height: DS.Frame.height)
            @unknown default:
                EmptyView()
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
    var mock = AssetsServiceMock()
    mock.modelToBeReturned = .init(data: [.fixture(name: "btc", symbol: "bitcoin")])
    return AssetsListView(
        viewModel: AssetsListViewModel(
            service: mock
        )
    )
}

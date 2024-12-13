//
//  ContentView.swift
//  PersonalProject
//
//  Created by Pedro Vargas on 13/12/24.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: ListViewModel = ListViewModel()
    @State var showLikedScreen = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            if let error = viewModel.error {
                errorView(error)
            } else if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else if let model = viewModel.model {
                
                VStack {
                    modelView(model)
                    Spacer()
                    NavigationLink(
                        isActive: $showLikedScreen,
                        destination: { likedView(.init(data: model.data.filter({ $0.isFavorite })))
                        },
                        label: { Text("Go To liked screen") })
                    
                }
            }
        }
        .task {
            await viewModel.observeSearchBar()
        }
        .searchable(text: $viewModel.searchText, prompt: "Search for title")
        .onAppear {
            viewModel.loadData()
        }
    }
    
    func modelView(_ model: ListModel) -> some View {
        list(model: model)
    }
    
    func likedView(_ model: ListModel) -> some View {
        list(model: model)
    }
    
    func list(model: ListModel) -> some View {
        List(model.data) { person in
            VStack(alignment: .leading) {
                HStack {
                    Text(person.title)
                        .font(.headline)
                    Text(person.name)
                        .font(.subheadline)
                    Spacer()
                    Button(
                        action: {viewModel.likeButtonClick(person.id)},
                        label:  { Image(systemName: person.isFavorite ? "heart.fill" : "heart") }
                    )
                }
                
            }
        }
    }
    
    func errorView(_ error: Error) -> some View {
        VStack {
            Text(error.localizedDescription)
            Button {
                    viewModel.loadData()
            } label: {
                Text("Retry")
            }

        }
    }
}

#Preview {
    ListView()
}

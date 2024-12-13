//
//  ListViewModel.swift
//  PersonalProject
//
//  Created by Pedro Vargas on 13/12/24.
//

import Foundation
import Combine

@MainActor
class ListViewModel: ObservableObject {
    @Published var model: ListModel?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var searchText: String = ""
    
    var currentModel: ListModel?

    var cancellable: AnyCancellable?
    
    func observeSearchBar() async {
        cancellable = $searchText
            .debounce(
                for: 1,
                scheduler: DispatchQueue.main
            )
            .sink(receiveValue: { [weak self] text in
                guard let self else { return }
                if text == "", let currentModel = currentModel {
                    model = currentModel
                } else {
                    self.searchData(text: text)
                }
            })
    }
    
    func loadData() {
        Task {
            isLoading = true
            try? await Task.sleep(nanoseconds: 4_000_000_000)
            isLoading = false
            model = .init(data: [
                .fixture(title: "1", name: "1"),
                .fixture(title: "2", name: "2"),
                .fixture(title: "3", name: "3"),
                .fixture(title: "4", name: "4"),
                .fixture(title: "5", name: "5")
            ]
            )
            currentModel = model
        }
    }
    
    func searchData(text: String) {
        Task {
            isLoading = true
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            guard let model = currentModel else {
                isLoading = false
                return
            }
            
            let newData = model.data.filter { $0.title == text }
            if newData.count > 0 {
                self.model = .init(data: newData)
            }
            
            isLoading = false
        }
        
    }
    
    func likeButtonClick(_ personID: UUID) {
        Task {
            guard let model else { return }
            let newData = model.data.map {
                return PersonData(
                    id: $0.id,
                    title: $0.title,
                    name: $0.name,
                    isFavorite: $0.id == personID ? !$0.isFavorite : $0.isFavorite
                )
            }
            self.model = .init(data: newData)
        }
        
    }
}

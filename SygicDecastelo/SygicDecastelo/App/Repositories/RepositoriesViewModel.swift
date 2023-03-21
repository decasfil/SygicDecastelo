//
//  RepositoriesViewModel.swift
//  SygicDecastelo
//
//  Created by Filip Decastelo on 21.03.2023.
//

import Foundation
import Combine

struct GithubRepository: Decodable, Identifiable {
    let id: Int
    let full_name: String
    let description: String?
    let updated_at: String
    let stargazers_count: Int
    let owner: RepositoryOwner
    let html_url: String
}

struct RepositoryOwner: Decodable {
    let avatar_url: String
}

class RepositoriesViewModel: ObservableObject {

    private let apiClient: ApiClient
    private var fetchDataPublisher: AnyCancellable?

    @Published var repos: [GithubRepository] = []

    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }

    func loadData() {
        fetchDataPublisher = apiClient
            .dataTaskPublisher(
                for: .init(path: "https://api.github.com/orgs/apple/repos", method: "get", headers: nil, body: nil)
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("### error \(error)")
                    }
                },
                receiveValue: { [weak self] (data: [GithubRepository]) in
                    print("### data \(data.count)")
                    self?.repos = data
                }
            )
    }
}

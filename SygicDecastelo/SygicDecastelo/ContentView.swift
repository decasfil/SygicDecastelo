//
//  ContentView.swift
//  SygicDecastelo
//
//  Created by Filip Decastelo on 21.03.2023.
//

import SwiftUI
import WebKit

struct ContentView: View {

    @ObservedObject var viewModel = RepositoriesViewModel(apiClient: ApiClient())

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.repos) { repo in
                    NavigationLink(destination: {
                        WebView(url: URL(string: repo.html_url)!)
                    }, label: {
                        RepoRow(repo: repo)
                            .padding()
                    })
                }
            }
            .listRowSeparator(.hidden)
            .listStyle(.plain)
            .onAppear {
                viewModel.loadData()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RepoRow: View {

    var repo: GithubRepository

    var body: some View {
        VStack {
            HStack {
                Text(repo.full_name)
                    .font(.title)
                Spacer()
                AsyncImage(url: URL(string: repo.owner.avatar_url), scale: 10)
            }
            repo.description.map { description in
                VStack {
                    Rectangle()
                        .fill(.gray)
                        .frame(height: 1)
                        .padding([.leading, .trailing], 5)

                    HStack {
                        Text(description)
                            .font(.subheadline)
                        Spacer()
                    }
                }
            }
            Rectangle()
                .fill(.gray)
                .frame(height: 1)
                .padding([.leading, .trailing], 5)

            Text("Stars \(repo.stargazers_count)")
        }
    }

}

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView

    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        DispatchQueue.main.async {
            view.load(URLRequest(url: url))
        }
        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        //
    }
}

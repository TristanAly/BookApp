//
//  AddBookViewModel.swift
//  BookApp
//
//  Created by apprenant1 on 18/01/2023.
//

import Foundation

enum ErrorMessage: Error {
    case noData
    case decodingError
    case badURL
    case badResponse
    
    var localizedDescription: String {
        switch self {
        case .noData:
            return "No data"
        case .decodingError:
            return "Error while decoding error"
        case .badURL:
            return "Missing URL"
        case .badResponse:
            return "Bad response"
        }
    }
}

class BookViewModel: ObservableObject {
    
    let BookApibaseURL = "https://books.googleapis.com/books/v1/volumes"
    
    @Published var results = [Item]()
    @Published var search = ""
    @Published var years = "2014"
    @Published var author = "author"
    @Published var category = "category"
    @Published var synopsie = "synopsie"
    @Published var title = "title"

    
    //MARK: get Movie by search
    func loadData(search: String) async {
        guard let query = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(BookApibaseURL)?q=\(query)") else {
            print(ErrorMessage.badURL)
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(BookResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.results = decodedResponse.items  // <--- here
                }
            }
        } catch {
            print(ErrorMessage.decodingError)
        }
    }
    
    // MARK: get Movie Data // error 500
    func getMovieData() async {
        guard let url = URL(string: ("\(BookApibaseURL)/1")) else {
            print(ErrorMessage.badURL)
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(BookResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.results = decodedResponse.items  // <--- here
                }
            }
        } catch {
            print(ErrorMessage.decodingError)
        }
    }
}

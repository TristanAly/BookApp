//
//  HomePage.swift
//  BookApp
//
//  Created by apprenant1 on 18/01/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomePage: View {
    
    @StateObject var BookVM = BookViewModel()
    
    var body: some View {
        NavigationView{
            List(BookVM.results) { item in  // <--- here
                NavigationLink{
                    DetailDownloadView(item: item)
                } label: {
                    labelView(item: item)
                }
            }.listStyle(.plain)
                .searchable(text: $BookVM.search, prompt: "search a book")
                .onChange(of: BookVM.search, perform: { newValue in
                    Task{
                       await BookVM.loadData(search: newValue)
                  }
                })
                .navigationTitle("Books")
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
            .environmentObject(BookViewModel())
    }
}

struct labelView: View {
    
    var item: Item
   var body: some View{
        HStack{
            if ((item.volumeInfo.imageLinks?.thumbnail.isEmpty) != nil) {
                WebImage(url: URL(string: item.volumeInfo.imageLinks?.thumbnail ?? "")).resizable().frame(width: 100,height: 150).cornerRadius(10)
            }
            else {
                Image("book")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100,height: 150)
                    .cornerRadius(10)
            }
            VStack(alignment: .leading) {
                Text(item.volumeInfo.title)
                    .font(.title3)
                if let authors = item.volumeInfo.authors ?? [] {
                    ForEach(authors, id: \.self) {
                        Text(" \($0)").font(.system(size: 18,weight: .light))
                            .padding(.vertical,1)
                    }
                }
            }
        }
   }
 }

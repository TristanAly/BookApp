//
//  BookDetailView.swift
//  BookApp
//
//  Created by apprenant1 on 18/01/2023.
//

import SwiftUI

struct BookDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let item: Book
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack{
                VStack{
                    Image("books")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200,height: 250)
                        .cornerRadius(8)
                    Text(item.title?.capitalized  ?? "")
                        .font(.title)
                        .bold()
                    Text(item.author?.capitalized  ?? "")
                        .font(.system(size: 22, weight: .light))
                    Text(item.years ?? "")
                        .bold()
                        .padding(.vertical,0.1)
                }
                .padding()
                HStack{
                    Text("Genre: ")
                        .font(.system(size: 18,weight: .heavy))
                        .underline()
                    Text(item.category?.capitalized ?? "")
                    
                }.padding(.horizontal)
                VStack(alignment: .leading){
                    HStack{
                        Text("Synopsie: ")
                            .font(.system(size: 18,weight: .heavy))
                            .underline()
                        Spacer()
                    }.padding()
                    Text(item.synopsie?.capitalized ?? "")
                        .multilineTextAlignment(.leading)
                        .lineLimit(0)
                        .padding(.horizontal)
                }
            }
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let vc = PersistenceController.preview.container.viewContext
        let request = Book.fetchRequest()
        let results = try! vc.fetch(request)
        NavigationStack{
            BookDetailView(item: results[0]).environment(\.managedObjectContext, vc)
        }
    }
}

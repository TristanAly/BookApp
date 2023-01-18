//
//  DetailDownloadView.swift
//  BookApp
//
//  Created by apprenant1 on 18/01/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailDownloadView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BookItem.title, ascending: true)],
        animation: .default) private var items: FetchedResults<BookItem>
    var item: Item
    private func addItem() {
        withAnimation {
            let newItem = BookItem(context: viewContext)
            newItem.title = item.volumeInfo.title
            newItem.urlImg = item.volumeInfo.imageLinks?.thumbnail
            newItem.desc = item.volumeInfo.description
            newItem.authors = item.volumeInfo.authors
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack{
                VStack{
                    if item.volumeInfo.imageLinks?.thumbnail != nil {
                        WebImage(url: URL(string: item.volumeInfo.imageLinks?.thumbnail ?? "")).resizable().frame(width: 100,height: 150).cornerRadius(10)
                    }
                    else {
                        Image("book")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200,height: 250)
                            .cornerRadius(10)
                    }
                    Text(item.volumeInfo.title.capitalized)
                        .font(.title2)
                        .bold()
                    ForEach(item.volumeInfo.authors ?? [], id: \.self) {
                            Text($0)
                                .font(.system(size: 18,weight: .light))
                        }
                .padding()
                    HStack{
                        Spacer()
                        Button {
                           addItem()
                        } label: {
                            Image(systemName: "arrow.down.to.line.circle")
                                .font(.system(size: 30,weight: .bold))
                        }
                        .padding(.horizontal, 30)
                    }
                 VStack(alignment: .leading){
                        HStack{
                            Text("Synopsie: ")
                                .font(.system(size: 18,weight: .heavy))
                                .underline()
                            Spacer()
                        }.padding()
                        Text(item.volumeInfo.description?.capitalized ?? "")
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct DetailDownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DetailDownloadView(item: Item(id: "", etag: "", volumeInfo: VolumeInfo(title: "test1", authors: ["String"], description: "description1", imageLinks: ImageLinks(thumbnail: "")))).environment(\.managedObjectContext, PersistenceController.preview2.container.viewContext)
    }
}

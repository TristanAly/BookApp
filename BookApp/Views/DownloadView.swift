//
//  DownloadView.swift
//  BookApp
//
//  Created by apprenant1 on 18/01/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DownloadView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BookItem.title, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<BookItem>
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(items, id: \.self) { item in
                    NavigationLink {
                        BookApiDetailView(item: item)
                    } label: {
                        HStack{
                            if item.urlImg != "" {
                                WebImage(url: URL(string: item.urlImg ?? "")).resizable().frame(width: 100,height: 150).cornerRadius(10)
                            }
                            else {
                                Image("book")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100,height: 150)
                                    .cornerRadius(10)
                            }
                            VStack(alignment: .leading){
                                Text(item.title?.capitalized ?? "")
                                    .font(.title)
                                    .bold()
                                    .padding(.vertical,8)
                                ForEach(item.authors ?? [], id: \.self) {
                                    Text($0.capitalized)
                                }
                            }
                            .padding()
                            .foregroundColor(.accentColor)
                        }
                    }
                }.onDelete(perform: deleteItems)
            }.listStyle(.plain)
            .navigationTitle("Download")
        }
    }
    // func to delete
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView().environment(\.managedObjectContext, PersistenceController.preview2.container.viewContext)
    }
}

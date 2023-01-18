//
//  ContentView.swift
//  BookApp
//
//  Created by apprenant1 on 18/01/2023.
//

import SwiftUI
import CoreData

struct ListBookView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Book.id, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Book>
    @State var show: Bool = false
    @State var search: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    NavigationLink {
                        BookDetailView(item: item)
                    } label: {
                        HStack{
                            Image("books")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100,height: 150)
                                .cornerRadius(10)
                            VStack(alignment: .leading){
                                Text(item.title?.capitalized ?? "")
                                    .font(.title)
                                    .bold()
                                    .padding(.vertical,8)
                                Text(item.author?.capitalized ?? "")
                                    .font(.system(size: 20, weight: .medium))
                                Text(item.years ?? "")
                                    .font(.system(size: 18, weight: .medium))
                                    
                                    
                            }
                            .padding()
                            .foregroundColor(.white)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
                .onMove(perform: moveItem)
            }.listStyle(.plain)
                .sheet(isPresented: $show) {
                    AddBookView()
                }
                .searchable(text: $search)
                .onChange(of: search) { newValue in
                    items.nsPredicate = searchPredicate(query: newValue)
                }
            
                .navigationTitle("My Library")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                
                    }
                    ToolbarItem{
                        Button {
                            show.toggle()
                        } label: {
                            Label("test", systemImage: "plus")
                        }
                    }
                }
        }
    }
// func search book with core data
    private func searchPredicate(query: String) -> NSPredicate? {
        if query.isEmpty { return nil }
        return NSPredicate(format: "%K BEGINSWITH[cd] %@",
                           #keyPath(Book.title), query)
    }
// func move item to place
    private func moveItem(at sets:IndexSet,destination:Int){
        let itemToMove = sets.first!
        
        if itemToMove < destination{
            var startIndex = itemToMove + 1
            let endIndex = destination - 1
            var startOrder = items[itemToMove].id
            while startIndex <= endIndex {
                items[itemToMove].id = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            items[itemToMove].id = startOrder
        }
        else if destination < itemToMove {
            var startIndex = destination
            let endIndex = itemToMove - 1
            var startOrder = items[destination].id + 1
            let newOrder = items[destination].id
            while startIndex <= endIndex {
                items[itemToMove].id = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            items[itemToMove].id = newOrder
        }
        do {
            try viewContext.save()
        } catch {
            
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    private func addItem() {
        withAnimation {
            let newItem = Book(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ListBookView_Previews: PreviewProvider {
    static var previews: some View {
        ListBookView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

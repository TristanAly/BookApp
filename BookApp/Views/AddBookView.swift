//
//  AddBookView.swift
//  BookApp
//
//  Created by apprenant1 on 18/01/2023.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State var addBookVM = BookViewModel()
    
    private func addItem() {
        withAnimation {
            let newItem = Book(context: viewContext)
            newItem.years = addBookVM.years
            newItem.author = addBookVM.author
            newItem.category = addBookVM.category
            newItem.synopsie = addBookVM.synopsie
            newItem.title = addBookVM.title
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    var body: some View {
        VStack{
            Form{
                Section("Details", content: {
                    TextField("title", text: self.$addBookVM.title)
                    TextField("author", text: self.$addBookVM.author)
                    TextField("année", text: self.$addBookVM.years)
                })
                
                Section("categorie", content: {
                    Picker("", selection: self.$addBookVM.category) {
                        Text("Roman").tag("Roman")
                        Text("Action").tag("Action")
                        Text("Thriller").tag("Thriller")
                        Text("Drame").tag("Drame")
                    }
                    .pickerStyle(.segmented)
                })
                Section("Resume", content: {
                    TextEditor(text: self.$addBookVM.synopsie)
                        .frame(height: 150)
                })
            }
            Button("Save") {
                addItem()
                dismiss()
            }
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}

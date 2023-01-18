//
//  BookApiDetailView.swift
//  BookApp
//
//  Created by apprenant1 on 18/01/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookApiDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var item: BookItem
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack{
                VStack{
                    
                        if item.urlImg != "" {
                            WebImage(url: URL(string: item.urlImg ?? "")).resizable().frame(width: 100,height: 150).cornerRadius(10)
                        }
                        else {
                            Image("book")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200,height: 250)
                                .cornerRadius(10)
                        }
                        Text(item.title?.capitalized ?? "")
                            .font(.title)
                            .bold()
                            .padding()
                    ForEach(item.authors ?? [], id: \.self) {
                        Text($0.capitalized)
                                .font(.system(size: 18,weight: .light))
                        }
                        VStack(alignment: .leading){
                            HStack{
                                Text("Synopsie: ")
                                    .font(.system(size: 18,weight: .heavy))
                                    .underline()
                                Spacer()
                            }.padding()
                            Text(item.desc?.capitalized ?? "")
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal)
                        }
                    }
            }
        }
    }
}

//
//  TabBarView.swift
//  BookApp
//
//  Created by apprenant1 on 18/01/2023.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            ListBookView()
            .tabItem {
                VStack{
                    Image(systemName: "house.circle.fill")
                    Text("Home")
                }
            }
            HomePage()
            .tabItem {
                VStack{
                    Image(systemName: "magnifyingglass.circle")
                    Text("search")
                }
            }
            DownloadView()
            .tabItem {
                VStack{
                    Image(systemName: "arrow.down.to.line.circle.fill")
                    Text("download")
                }
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}

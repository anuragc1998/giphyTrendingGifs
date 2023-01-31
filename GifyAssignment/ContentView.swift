//
//  ContentView.swift
//  GifyAssignment
//
//  Created by macbook on 27/01/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = Constants.Tab.home
    @EnvironmentObject var giphyViewModel: GiphyViewModel
    
    var body: some View {
        // Wrap inside project for nested screens and navigation
        NavigationView{
            // can use enums to make tab items order and visibility dynamic via api
            TabView(selection: $selectedTab) {
                // List all trending gifs
                HomeView()
                    .environmentObject(giphyViewModel)
                    .onTapGesture {
                        selectedTab = Constants.Tab.home
                    }
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(Constants.Tab.home)

                // Favourite gifs
                FavouriteView()
                    .onTapGesture {
                        selectedTab = Constants.Tab.favourites
                    }
                    .tabItem {
                        Label("Favourites", systemImage: "heart")
                    }
                    .tag(Constants.Tab.favourites)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  FavouriteView.swift
//  GifyAssignment
//
//  Created by macbook on 29/01/23.
//

import SwiftUI
import RealmSwift

struct FavouriteView: View {
    // db wrapper for favourites
    @ObservedResults(GiphyDatumRealm.self) var favouritesGiphys
    // updated viewModel injected from app launch
    @EnvironmentObject var giphyViewModel: GiphyViewModel
    
    var favourites: [GiphyDatum]{
        favouritesGiphys.map({GiphyDatum(data: $0)})
    }
    
    var body: some View {
        // show empty and favourites list according to db instance
        VStack{
            if favourites.count > 0{
                favouritesListView
            }
            else{
                noFavourtiesView
            }
        }
        .padding(.top, 8)
        .background(Color.gray.opacity(0.1))
        
    }
    
    var favouritesListView: some View{
        ScrollView(showsIndicators: false){
            ForEach(favourites, id: \.self) { result in
                GifView(gifData: result)
            }
        }
    }
    
    var noFavourtiesView: some View{
        VStack{
            Spacer()
            Text("No favourites found :(")
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(minHeight: 0, maxHeight: .infinity)
            Spacer()
        }
    }
}

struct FavouriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteView()
    }
}

//
//  HomeView.swift
//  GifyAssignment
//
//  Created by macbook on 29/01/23.
//

import SwiftUI

struct HomeView: View {
    // updated viewModel injected from app launch
    @EnvironmentObject var giphyViewModel: GiphyViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false){
            ForEach(giphyViewModel.giphyData , id: \.self) { result in
                GifView(gifData: result)
            }
        }
        .padding(.top, 8)
        .background(Color.gray.opacity(0.1))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

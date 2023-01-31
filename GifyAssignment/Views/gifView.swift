//
//  gifView.swift
//  GifyAssignment
//
//  Created by macbook on 30/01/23.
//

import SwiftUI

struct GifView: View {
    // updated viewModel injected from app launch
    @EnvironmentObject var giphyViewModel: GiphyViewModel
    
    var gifData: GiphyDatum?
    
    // favourite status for the current gif
    @State var isFavourite: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            
            returnRemoteImage(urlString: gifData?.images?.original?.url)
                .resizable()
                .scaledToFit()
            
            HStack{
                
                Text(gifData?.title ?? "")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.caption2)
                    .foregroundColor(Color.black.opacity(0.6))
                
                Spacer()
                
                Image(systemName: isFavourite ? "heart.fill" : "heart")
                    .renderingMode(.template)
                    .foregroundColor(Color.red)
                    .frame(width: 25, height: 25)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.white)
                            .shadow(color: Color.gray.opacity(1), radius: 2, x: 0, y: 1)
                    )
                    // toggle status on tap
                    .onTapGesture {
                        isFavourite = !isFavourite
                    }
                    // respective db operation for CTA
                    .onChange(of: isFavourite) { isFavourite in
                        if isFavourite{
                            giphyViewModel.dbHandler?.addFavourite(gifData)
                        }
                        else{
                            giphyViewModel.dbHandler?.deleteFavourite(gifData)
                        }
                    }
                
            }
            .padding([.all], 8)
        }
        .onAppear(){
            // check if current gif is one of the favourite gifs and update selection state
            self.isFavourite = giphyViewModel.dbHandler?.isFavourite(giphyData: gifData) ?? false
        }
        .background(Color.white)
        .cornerRadius(8.0)
        .shadow(color: Color.gray.opacity(1), radius: 2, x: 0, y: 1)
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
    }
}

struct gifView_Previews: PreviewProvider {
    static var previews: some View {
        GifView(gifData: nil)
    }
}

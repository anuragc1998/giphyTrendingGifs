//
//  Helpers+Extensios.swift
//  GifyAssignment
//
//  Created by macbook on 29/01/23.
//

import Foundation
import SDWebImageSwiftUI

func returnRemoteImage(urlString: String?) -> WebImage {
    // sanitise image/gif urls optimisations such as spaces, encoding errors etc
    guard let icon = urlString?.removingPercentEncoding?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.replacingOccurrences(of: " ", with: "%20"),
          let url = URL(string: icon) else {
        return WebImage(url: nil)
    }
    
    return WebImage(url: url)
}

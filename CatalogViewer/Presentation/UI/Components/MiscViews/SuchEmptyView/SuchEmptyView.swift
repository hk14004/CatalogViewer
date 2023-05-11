//
//  SuchEmptyView.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import SwiftUI
import Kingfisher

struct SuchEmptyView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color("RedactedImage"))
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                KFImage(URL(string: "https://www.pedestrian.tv/wp-content/uploads/2021/06/13/doge-auction-.jpg?quality=80&resize=1280,720"))
                    .resizable()
                    .fade(duration: 0.3)
                    .forceTransition()
                    .scaledToFill()
                    .clipped()
            }
            .cornerRadius(12)
            .layoutPriority(2)
            .overlay(alignment: .bottom, content: {
                Text("Such empty :) \n Come back next time...")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .padding()
            })
            .padding(.vertical, 4)
    }
}

struct SuchEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        SuchEmptyView()
    }
}

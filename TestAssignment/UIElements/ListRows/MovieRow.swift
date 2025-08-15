//
//  MovieRow.swift
//  TestAssignment
//
//  Created by Himanshu Sharma on 15/08/25.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct MovieRow: View {
    let movie: Movie
    let onTap:() -> Void
    private let imgBaseURL: String = "https://image.tmdb.org/t/p/w500"
    
    var body: some View {
        HStack(alignment:.top){
            WebImage(url: URL(string: "\(imgBaseURL)\(movie.posterPath)")).resizable().scaledToFit().frame(width:100,height:150).clipShape(RoundedRectangle(cornerRadius: 10)).overlay(content:{
                RoundedRectangle(cornerRadius: 10).stroke(.black,lineWidth: 2)
            })
            VStack{
                Text(movie.title).font(.system(size: 20)).fontWeight(.semibold).foregroundStyle(.black).frame(maxWidth:.infinity,alignment:.leading)
                Text("Rating: \(String(format: "%.2f", movie.voteAverage))").font(.system(size: 14)).fontWeight(.regular).foregroundStyle(.black).frame(maxWidth:.infinity,alignment:.leading)
                Text("Released On: \(movie.releaseDate)").font(.system(size: 14)).fontWeight(.regular).foregroundStyle(.black).frame(maxWidth:.infinity,alignment:.leading)
            }.frame(maxWidth:.infinity).padding(.vertical,10)
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            onTap()
        }
    }
}

//
//  MovieDetailsView.swift
//  TestAssignment
//
//  Created by Himanshu Sharma on 15/08/25.
//

import SwiftUI

struct MovieDetailsView: View {
    let movie:Movie
    var body: some View {
        VStack{
            MovieRow(movie: movie, onTap: {})
            Text("Language: \(movie.originalLanguage)").font(.system(size: 14)).fontWeight(.medium).frame(maxWidth:.infinity,alignment:.leading).padding(.vertical,10)
            Text(movie.overview).font(.system(size: 14)).fontWeight(.regular).frame(maxWidth:.infinity,alignment:.leading).multilineTextAlignment(.leading).padding(.vertical,10)
            
            Spacer()
        }
        .padding(.horizontal,20)
        .frame(maxWidth:.infinity,maxHeight: .infinity)
    }
}

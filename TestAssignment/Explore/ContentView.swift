//
//  ContentView.swift
//  TestAssignment
//
//  Created by Himanshu Sharma on 15/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var exploreModel: ExploreModel = ExploreModel()
    var body: some View {
        NavigationStack{
            VStack {
                if let moviesData = exploreModel.moviesData {
                    List(moviesData,id:\.self){ movie in
                        MovieRow(movie: movie,onTap:{
                            exploreModel.showMovieDetails(movie: movie)
                        })
                    }
                    .refreshable {
                        exploreModel.refreshToNextPage()
                    }
                }
            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(.white)
            .toolbar(.hidden)
            .onAppear{
                exploreModel.refreshToNextPage()
            }
            .navigationDestination(isPresented: $exploreModel.showDetails, destination: {
                if let movie = exploreModel.movieSelected {
                    MovieDetailsView(movie:movie)
                }
            })
        }
    }
}


#Preview {
    ContentView()
}

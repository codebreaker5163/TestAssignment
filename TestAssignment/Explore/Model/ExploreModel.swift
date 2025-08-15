//
//  ExploreModel.swift
//  TestAssignment
//
//  Created by Himanshu Sharma on 15/08/25.
//

import Foundation

class ExploreModel: ObservableObject {
    @Published var moviesData: [Movie]? = nil
    @Published var errorToDisplay: String? = nil
    
    @Published var showDetails: Bool = false  // We can use NavigationPath in production, but at this moment it's too much for assignment
    
    var currentPage: Int = 0
    var movieSelected: Movie? = nil
    
    
    func fetchMovies() async {
        do{
            let data = try await APIHandler.shared.makeGETRequest(to: APIEndpoints.discover.rawValue, payload: DiscoverRequest(page: currentPage))
                updateMoviesDataOnMain(data)
                let url = try saveDataToTextFile(data) // We don't need fileurl as we are using default name of file
        }catch{
            // Fallback to local storage (If exist)
            fetchFromLocalFile()
        }
    }
    
    private func updateMoviesDataOnMain(_ data: Data){
        DispatchQueue.main.async {
            do{
                if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any], let moviesObject = jsonObject["results"] {
                    let moviedata = try JSONSerialization.data(withJSONObject: moviesObject)
                    let decoded = try JSONDecoder().decode([Movie].self, from: moviedata)
                    if self.moviesData == nil{
                        self.moviesData = decoded.sorted{$0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending}
                    }else{
                        var temp = self.moviesData
                        temp?.append(contentsOf: decoded)
                        self.moviesData = temp?.sorted{$0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending}
                    }
                }
            }catch{
                self.errorToDisplay = error.localizedDescription
            }
        }
    }
    
    private func fetchFromLocalFile(){
        do{
            let data = try readDataFromTextFile()
            updateMoviesDataOnMain(data)
        }catch{
            errorToDisplay = noMoviesAvailable
        }
    }
    
    private func saveDataToTextFile(_ data: Data, fileName: String = "MoviesData") throws -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            // If file exists, we will append data to existing file
            if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
                try fileHandle.seekToEnd()
                fileHandle.write(data)
                try fileHandle.close()
            } else {
                // If error occurs, we just overwrite the text file
                try data.write(to: fileURL)
            }
        } else {
            // If file doees not exist, we will create a new one and write into it.
            try data.write(to: fileURL)
        }

        print("Saved to: \(fileURL)")
        return fileURL
    }

    
    private func readDataFromTextFile(fileName: String = "MoviesData") throws -> Data {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        let data = try Data(contentsOf: fileURL)
        return data
    }
    
    func refreshToNextPage(){
        currentPage += 1
        Task{
            await fetchMovies()
        }
    }
    
    func showMovieDetails(movie:Movie){
        movieSelected = movie
        showDetails = true
        
    }
}

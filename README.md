## iOS Developer Test Assignment

As requested, here’s my completed test assignment for the **iOS Developer** role.

### Features Implemented
- **Fetch popular movies** from [TMDB API](https://developer.themoviedb.org/)
- **Pagination**: Starts from page 1 and loads the next page when the user performs *pull-to-refresh* on the list
- **Movie List**: Displays poster, title, rating, and release date in each row
- **Movie Details**: Tapping a movie opens a detailed view screen
- **Offline Mode**: We are using a text file, to save bytes, and read it from that file in case any error occurs, including offline.
  

### Notes
As part of the optional bonus tasks, I have implemented *pull-to-refresh*.  
Other suggested bonus features were beyond the intended scope of this test assignment for a job role. I hope this is understandable.

## Here’s a quick breakdown of the app flow shown in the video:

- **Landing Screen**: ContentView.swift displays a list of movies. On onAppear(), it triggers an API call via ExploreModel.swift.

- **List Display**: If data is available, it shows movie rows in a simple SwiftUI List.

**Inside ExploreModel:**

- fetchMovies() calls the TMDB API.

- API URL and token are stored in Info.plist for security.

- On receiving data, it’s decoded into a [Movie] (marked @Published) so the UI updates automatically.

- The raw data is also saved as bytes to a local text file for offline use. If the API call fails, we load data from that file (fallback in the catch block).

**Other details:**

- API calls arer done through APIHandler (It's a singleton)

- Pagination is handled with an integer counter. Pull-to-refresh loads the next page.

- The movie detail screen is straightforward and displays tapped movie details.


https://github.com/user-attachments/assets/aa23441a-9731-4524-9f9d-4bc76ca4a890


import Architecture
import SwiftUI
import LinkNavigator

@main
struct AppMain: App {

  @StateObject var viewModel = AppMainViewModel()
  
  var body: some Scene {
    WindowGroup {
      LinkNavigationView(
        linkNavigator: viewModel.linkNavigator,
        item: .init(path: Link.Movie.Path.home.rawValue, items: ""))
    }
  }
}

import Foundation
import SwiftUI

extension MovieDetailPage {
  struct MovieOverviewComponent {
    let viewState: ViewState
  }
}

extension MovieDetailPage.MovieOverviewComponent {
}

extension MovieDetailPage.MovieOverviewComponent: View {
  var body: some View {
    VStack(alignment: .leading) {    
      Text(viewState.text)
    }
  }
}

extension MovieDetailPage.MovieOverviewComponent {
  struct ViewState: Equatable {
    let text: String
  }
}


import Foundation
import SwiftUI

extension MovieDetailPage {
  struct MovieReviewComponent {
    let viewState: ViewState
  }
}

extension MovieDetailPage.MovieReviewComponent {
}

extension MovieDetailPage.MovieReviewComponent: View {
  var body: some View {
    HStack {
      Text(viewState.text)
      Spacer()
      Image(systemName: "chevron.right")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 10, height: 10)
      
    }
  }
}

extension MovieDetailPage.MovieReviewComponent {
  struct ViewState: Equatable {
    let text: String
  }
}



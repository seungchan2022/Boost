import Domain
import Foundation
import SwiftUI

// MARK: - MovieDetailPage.RecommendedMovieListComponent

extension MovieDetailPage {
  struct RecommendedMovieListComponent {
    let viewState: ViewState
    let selectAction: (MovieDetailDomain.Response.RecommendedMovieResult) -> Void
  }
}

extension MovieDetailPage.RecommendedMovieListComponent { }

// MARK: - MovieDetailPage.RecommendedMovieListComponent + View

extension MovieDetailPage.RecommendedMovieListComponent: View {
  var body: some View {
    VStack {
      HStack {
        Text("Recommended Movies")
        Text("See all")
          .foregroundColor(.customGreenColor)

        Spacer()

        Image(systemName: "chevron.right")
          .resizable()
          .frame(width: 8, height: 10)
      }
      .background(.white)
      .onTapGesture {
        selectAction(MovieDetailDomain.Response.RecommendedMovieResult())
        print("Tapped Recommended Movie")
      }

      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 48) {
          ForEach(viewState.itemList) { item in
            ItemComponent(item: item)
          }
        }
      }
    }
    .padding(.vertical)
    .padding(.horizontal, 16)
  }
}

// MARK: - MovieDetailPage.RecommendedMovieListComponent.ViewState

extension MovieDetailPage.RecommendedMovieListComponent {
  struct ViewState: Equatable {
    let itemList: [RecommendedMovieItem]

    init(rawValue: [MovieDetailStore.RecommendedMovieResultItemScope]) {
      itemList = rawValue.map(RecommendedMovieItem.init(rawValue:))
    }
  }
}

// MARK: - MovieDetailPage.RecommendedMovieListComponent.ViewState.RecommendedMovieItem

extension MovieDetailPage.RecommendedMovieListComponent.ViewState {
  struct RecommendedMovieItem: Equatable, Identifiable {
    let id: Int
    let title: String
    let imageURL: String
    let voteAverage: Double
    let rawValue: MovieDetailDomain.Response.RecommendedMovieResultItem

    init(rawValue: MovieDetailStore.RecommendedMovieResultItemScope) {
      id = rawValue.item.id
      title = rawValue.item.title
      imageURL = rawValue.imageURL + (rawValue.item.posterPath ?? "")
      voteAverage = rawValue.item.voteAverage
      self.rawValue = rawValue.item
    }
  }
}

// MARK: - MovieDetailPage.RecommendedMovieListComponent.ItemComponent

extension MovieDetailPage.RecommendedMovieListComponent {
  fileprivate struct ItemComponent {
    let item: ViewState.RecommendedMovieItem
  }
}

// MARK: - MovieDetailPage.RecommendedMovieListComponent.ItemComponent + View

extension MovieDetailPage.RecommendedMovieListComponent.ItemComponent: View {
  var body: some View {
    Button(action: { }) {
      VStack {
        AsyncImage(
          url: .init(string: item.imageURL),
          content: { image in
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
          },
          placeholder: {
            Rectangle()
              .fill(.gray)
              .frame(width: 90)
          })
          .frame(height: 140)
          .clipShape(RoundedRectangle(cornerRadius: 10))
          .shadow(radius: 10)

        Text(item.title)
          .font(.footnote)

        Circle()
          .trim(from: 0, to: item.voteAverage / 10)
          .stroke(
            style: StrokeStyle(lineWidth: 2, dash: [1, 1.5]))
          .rotationEffect(.degrees(-90))
          .frame(width: 40, height: 40)
          .foregroundColor(Color.lineColor(item.voteAverage))
          .shadow(color: Color.lineColor(item.voteAverage), radius: 5, x: 0, y: 0)
          .overlay(
            Text("\(Int(item.voteAverage * 10))%")
              .font(.system(size: 10)))
      }
    }
    .foregroundColor(Color(.label))
    .frame(width: 120)
    .lineLimit(0)
  }
}

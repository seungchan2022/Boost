import Domain
import Foundation
import SwiftUI

// MARK: - MovieDetailPage.SimilarMovieListComponent

extension MovieDetailPage {
  struct SimilarMovieListComponent {
    let viewState: ViewState
    let selectAction: (MovieDetailDomain.Response.SimilarMovieResult) -> Void
  }
}

extension MovieDetailPage.SimilarMovieListComponent { }

// MARK: - MovieDetailPage.SimilarMovieListComponent + View

extension MovieDetailPage.SimilarMovieListComponent: View {
  var body: some View {
    VStack {
      HStack {
        Text("Similar Movies")
        Text("See all")
          .foregroundColor(.customGreenColor)

        Spacer()

        Image(systemName: "chevron.right")
          .resizable()
          .frame(width: 8, height: 10)
      }
      .background(.white)
      .onTapGesture {
        selectAction(MovieDetailDomain.Response.SimilarMovieResult())
        print("Tapped Similar Movie")
      }

      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 24) {
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

// MARK: - MovieDetailPage.SimilarMovieListComponent.ViewState

extension MovieDetailPage.SimilarMovieListComponent {
  struct ViewState: Equatable {
    let itemList: [SimilarMovieItem]

    init(rawValue: [MovieDetailStore.SimilarMovieResultItemScope]) {
      itemList = rawValue.map(SimilarMovieItem.init(rawValue:))
    }
  }
}

// MARK: - MovieDetailPage.SimilarMovieListComponent.ViewState.SimilarMovieItem

extension MovieDetailPage.SimilarMovieListComponent.ViewState {
  struct SimilarMovieItem: Equatable, Identifiable {
    let id: Int
    let title: String
    let imageURL: String
    let voteAverage: Double
    let rawValue: MovieDetailDomain.Response.SimilarMovieResultItem

    init(rawValue: MovieDetailStore.SimilarMovieResultItemScope) {
      id = rawValue.item.id
      title = rawValue.item.title
      imageURL = rawValue.imageURL + (rawValue.item.posterPath ?? "")
      voteAverage = rawValue.item.voteAverage
      self.rawValue = rawValue.item
    }
  }
}

// MARK: - MovieDetailPage.SimilarMovieListComponent.ItemComponent

extension MovieDetailPage.SimilarMovieListComponent {
  fileprivate struct ItemComponent {
    let item: ViewState.SimilarMovieItem
  }
}

// MARK: - MovieDetailPage.SimilarMovieListComponent.ItemComponent + View

extension MovieDetailPage.SimilarMovieListComponent.ItemComponent: View {
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

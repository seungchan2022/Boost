import Domain
import Foundation
import SwiftUI

// MARK: - MovieDetailPage.CastListComponent

extension MovieDetailPage {
  struct CastListComponent {
    let viewState: ViewState
    let selectAction: (MovieDetailStore.MovieCreditResultScope) -> Void
  }
}

extension MovieDetailPage.CastListComponent {
  private var filterItemList: [ViewState.CastItem] {
    viewState.itemList.reduce(into: [ViewState.CastItem]()) { curr, next in
      if !curr.contains(where: { $0.id == next.id }) {
        curr.append(next)
      }
    }
  }
}

// MARK: - MovieDetailPage.CastListComponent + View

extension MovieDetailPage.CastListComponent: View {
  var body: some View {
    VStack {
      HStack {
        Text("Cast")
        Text("See all")
          .foregroundColor(.customGreenColor)

        Spacer()

        Image(systemName: "chevron.right")
          .resizable()
          .frame(width: 8, height: 10)
      }
      .background(.white)
      .onTapGesture {
        selectAction(viewState.rawValue)
        print("Tapped Cast See all")
      }

      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(filterItemList) { item in
            ItemComponent(item: item)
              .background(.white)
          }
        }
      }
    }
    .padding(.vertical)
    .padding(.horizontal, 16)
  }
}

// MARK: - MovieDetailPage.CastListComponent.ViewState

extension MovieDetailPage.CastListComponent {
  struct ViewState: Equatable {
    let itemList: [CastItem]
    let rawValue: MovieDetailStore.MovieCreditResultScope

    init(rawValue: MovieDetailStore.MovieCreditResultScope) {
      itemList = rawValue.castList.map(CastItem.init(rawValue:))
      self.rawValue = rawValue
    }
  }
}

// MARK: - MovieDetailPage.CastListComponent.ViewState.CastItem

extension MovieDetailPage.CastListComponent.ViewState {
  struct CastItem: Equatable, Identifiable {
    let id: Int // cast id
    let name: String
    let character: String
    let imageURL: String
    let rawValue: MovieDetailDomain.Response.CastResultItem

    init(rawValue: MovieDetailStore.CastResultItemScope) {
      id = rawValue.item.id
      name = rawValue.item.name
      character = rawValue.item.character
      imageURL = rawValue.imageURL + (rawValue.item.profileImage ?? "")
      self.rawValue = rawValue.item
    }
  }
}

// MARK: - MovieDetailPage.CastListComponent.ItemComponent

extension MovieDetailPage.CastListComponent {
  fileprivate struct ItemComponent {
    let item: ViewState.CastItem
  }
}

// MARK: - MovieDetailPage.CastListComponent.ItemComponent + View

extension MovieDetailPage.CastListComponent.ItemComponent: View {
  var body: some View {
    Button(action: { }) {
      VStack(alignment: .center) {
        // API로 받아오는 데이터가 nil이 아니라 ""(빈문자열)로 표시 될수 있으므로 != nil 대신 이런 방식으로 사용
        if !item.imageURL.isEmpty {
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
                .frame(width: 70)
            })
            .frame(height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 10))

          Text(item.name)
            .font(.footnote)
            .foregroundColor(Color(.label))
          Text(item.character)
            .font(.caption)
            .foregroundColor(.gray)
        }
      }
      .frame(width: 90)
      .lineLimit(0)
    }
  }
}

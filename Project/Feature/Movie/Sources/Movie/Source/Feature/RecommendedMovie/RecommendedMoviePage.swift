import Architecture
import ComposableArchitecture
import Foundation
import SwiftUI

// MARK: - RecommendedMoviePage

struct RecommendedMoviePage {

  private let store: StoreOf<RecommendedMovieStore>
  @ObservedObject private var viewStore: ViewStoreOf<RecommendedMovieStore>

  init(store: StoreOf<RecommendedMovieStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }
}

extension RecommendedMoviePage {
  private var itemListComponentViewState: ItemListComponent.ViewState {
    .init(rawValue: viewStore.fetchRecommendedMovie.value.resultList)
  }
}

// MARK: View

extension RecommendedMoviePage: View {
  var body: some View {
    ScrollView {
      VStack {
        ItemListComponent(viewState: itemListComponentViewState)
      }
      .padding(.leading, 12)
    }
    .onAppear {
      viewStore.send(.getRecommendedMovie)
    }
    .onDisappear {
      viewStore.send(.teardown)
    }
  }
}

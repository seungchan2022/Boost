import Architecture
import ComposableArchitecture
import Foundation
import SwiftUI

// MARK: - CrewPage

struct CrewPage {

  private let store: StoreOf<CrewStore>
  @ObservedObject private var viewStore: ViewStoreOf<CrewStore>

  init(store: StoreOf<CrewStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }
}

extension CrewPage {
  private var itemListComponentViewState: ItemListComponent.ViewState {
    .init(rawValue: viewStore.fetchMovieCrew.value.crewList)
  }
}

extension CrewPage {
  private var isLoading: Bool {
    viewStore.fetchMovieCrew.isLoading
  }
}

// MARK: View

extension CrewPage: View {
  var body: some View {
    ScrollView {
      VStack {
        ItemListComponent(viewState: itemListComponentViewState)
      }
      .background(Color.white)
      .cornerRadius(10)
      .padding(.bottom)
      .padding(.horizontal, 16)
    }
    .background(Color.customBgColor)
    .onAppear {
      viewStore.send(.getMovieCrew)
    }
    .onDisappear {
      viewStore.send(.teardown)
    }
  }
}

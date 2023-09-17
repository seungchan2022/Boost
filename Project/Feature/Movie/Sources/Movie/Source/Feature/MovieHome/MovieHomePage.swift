import Foundation
import Architecture
import SwiftUI
import ComposableArchitecture
import DesignSystem

struct MovieHomePage {
  
  private let store: StoreOf<MovieHomeStore>
  @ObservedObject private var viewStore: ViewStoreOf<MovieHomeStore>
  
  init(store: StoreOf<MovieHomeStore>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
  }
}

extension MovieHomePage {
  private var searchComponentViewState: SearchComponent.ViewState {
    .init(placeHolder: "Serch any movies or person")
  }
  
  private var itemListComponentViewState: ItemListComponent.ViewState {
    .init(rawValue: viewStore.fetchNowPlaying.value.resultList)
  }
  
  private var searchResultMoviesComponentViewState: SearchResultMoviesComponent.ViewState {
    .init(itemList: [], keywordList: [])
  }
  
  private var searchResultPeopleComponenetViewState: SearchResultPeopleComponenet.ViewState {
//    .init(text: "SearchResultPeopleComponenet")
    .init(
      profileList: [
        SearchResultPeopleComponenet.ViewState.ProfileItem(
          name: "Florence Pugh",
          workList: ["Midsommar", "Black Wido", "Little Women"]),
        SearchResultPeopleComponenet.ViewState.ProfileItem(
          name: "Morgan Freeman",
          workList: ["Se7en", "The Shawshank Redemption", "Lucy"]),
        SearchResultPeopleComponenet.ViewState.ProfileItem(
          name: "Rebecca Ferguson",
          workList: ["Dune", "The Girl on the Train", "Life"]),
        SearchResultPeopleComponenet.ViewState.ProfileItem(
          name: "Travis Fimmel",
          workList: ["Warcraft", "Danger Close: The Battle of Long Tan"]),
        SearchResultPeopleComponenet.ViewState.ProfileItem(
          name: "Dakota Fanning",
          workList: ["Coraline", "War of the Worlds", "Man on Fire"]),
      ])
  }
}

extension MovieHomePage {
  private var isLoading: Bool {
    viewStore.fetchNowPlaying.isLoading
  }
}

extension MovieHomePage: View {
  
  var body: some View {
    VStack {
      Text("페이지 결과 값 \(viewStore.fetchNowPlaying.value.totalResult)")
      Text("현재 아이템 갯수 \(viewStore.fetchNowPlaying.value.resultList.count)")
      // 서치뷰
      SearchComponent(
        viewState: searchComponentViewState,
        keyword: viewStore.$keyword,
        throttleAction: { viewStore.send(.onUpdateKeyword) },
        clearAction: { viewStore.send(.onClearKeyword)
        })
      .padding(.trailing, 16)
      .padding(.bottom, 8)
      
      Divider()
      
      if viewStore.keyword.isEmpty {
        // 아이템 리스트
        ItemListComponent(
          viewState: itemListComponentViewState, nextPageAction: { viewStore.send(.getNowPlay)})
      } else {
        Group {
          Picker("", selection: viewStore.$searchFocus) {
            Text("Movies").tag(MovieHomeStore.State.SearchType.movies)
            Text("People").tag(MovieHomeStore.State.SearchType.people)
          }
          .pickerStyle(SegmentedPickerStyle())
          .padding(.trailing, 16)
          
          Divider()
          
          switch viewStore.searchFocus {
          case .movies:
            // 서치 했을때의 무비 리스트
            SearchResultMoviesComponent(
              viewState: searchResultMoviesComponentViewState)
            
          case .people:
            // 서치 했을때의 사람 리스트
            SearchResultPeopleComponenet(
              viewState: searchResultPeopleComponenetViewState)
          }
        }
      }
      Spacer()
    }
    .padding(.leading, 16)
    .navigationTitle("Now Playing")
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: { }) {
          Image(systemName: "gearshape")
            .resizable()
            .foregroundColor(.customYellowColor)
        }
      }
    }
    .setRequestFlightView(isLoading: isLoading)
    .onAppear {
      viewStore.send(.getNowPlay)
    }
    .onDisappear {
      viewStore.send(.teardown)
    }
  }
}

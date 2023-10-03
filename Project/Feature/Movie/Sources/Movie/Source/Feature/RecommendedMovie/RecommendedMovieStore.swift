import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - RecommendedMovieStore

public struct RecommendedMovieStore {
  let pageID: String
  let env: RecommendedMovieEnvType
  init(pageID: String = UUID().uuidString, env: RecommendedMovieEnvType) {
    self.pageID = pageID
    self.env = env
  }
}

// MARK: RecommendedMovieStore.State

extension RecommendedMovieStore {
  public struct State: Equatable {
    let movieID: Int

    init(movieID: Int) {
      self.movieID = movieID
      _fetchRecommendedMovie = .init(.init(isLoading: false, value: .init()))
    }

    @Heap var fetchRecommendedMovie: FetchState.Data<MovieDetailDomain.Response.RecommendedMovieResult>
  }
}

// MARK: - MyListsStore.State.ListType

extension RecommendedMovieStore.State { }

// MARK: - RecommendedMovieStore.Action

extension RecommendedMovieStore {
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case getRecommendedMovie

    case fetchRecommendedMovie(Result<MovieDetailDomain.Response.RecommendedMovieResult, CompositeErrorDomain>)

    case throwError(CompositeErrorDomain)
  }
}

// MARK: - RecommendedMovieStore.CancelID

extension RecommendedMovieStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestRecommendedMovie
  }
}

// MARK: - RecommendedMovieStore + Reducer

extension RecommendedMovieStore: Reducer {
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })

      case .getRecommendedMovie:
        state.fetchRecommendedMovie.isLoading = false
        return .concatenate(
          env.recommendedMovie(state.movieID)
            .map(Action.fetchRecommendedMovie)
            .cancellable(pageID: pageID, id: CancelID.requestRecommendedMovie, cancelInFlight: true))

      case .fetchRecommendedMovie(let result):
        state.fetchRecommendedMovie.isLoading = false
        switch result {
        case .success(let content):
          state.fetchRecommendedMovie.value = content
          return .none
        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .throwError(let error):
        print(error)
        return .none
      }
    }
  }
}

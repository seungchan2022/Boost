import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - MovieDetailStore

public struct MovieDetailStore {
  let pageID: String
  let env: MovieDetailEnvType
  init(pageID: String = UUID().uuidString, env: MovieDetailEnvType) {
    self.pageID = pageID
    self.env = env
  }
}

// MARK: MovieDetailStore.State

extension MovieDetailStore {
  public struct State: Equatable {
    let movieID: Int

    init(movieID: Int) {
      self.movieID = movieID
      _fetchMovieCard = .init(.init(isLoading: false, value: .init()))
      _fetchMovieReview = .init(.init(isLoading: false, value: .init()))
      _fetchMovieCredit = .init(.init(isLoading: false, value: .init()))
      _fetchSimilarMovie = .init(.init(isLoading: false, value: .init()))
      _fetchRecommendedMovie = .init(.init(isLoading: false, value: .init()))
    }

    @Heap var fetchMovieCard: FetchState.Data<MovieCardResultScope>
    @Heap var fetchMovieReview: FetchState.Data<MovieDetailDomain.Response.MovieReviewResult>
    @Heap var fetchMovieCredit: FetchState.Data<MovieCreditResultScope>
    @Heap var fetchSimilarMovie: FetchState.Data<SimilarMovieResultScope>
    @Heap var fetchRecommendedMovie: FetchState.Data<RecommendedMovieResultScope>
  }

  public struct MovieCardResultScope: Equatable {
    let imageURL: String
    let item: MovieDetailDomain.Response.MovieCardResult

    init(
      imageURL: String = "",
      item: MovieDetailDomain.Response.MovieCardResult = .init())
    {
      self.imageURL = imageURL
      self.item = item
    }
  }

  public struct MovieCreditResultScope: Equatable, Codable {
    let id: Int
    let castList: [CastResultItemScope]
    let crewList: [CrewResultItemScope]

    init(
      id: Int = .zero,
      castList: [CastResultItemScope] = [],
      crewList: [CrewResultItemScope] = [])
    {
      self.id = id
      self.castList = castList
      self.crewList = crewList
    }
  }

  public struct CastResultItemScope: Equatable, Identifiable, Codable {
    public let imageURL: String
    public let item: MovieDetailDomain.Response.CastResultItem
    public var id: Int { item.id }
  }

  public struct CrewResultItemScope: Equatable, Identifiable, Codable {
    public let imageURL: String
    public let item: MovieDetailDomain.Response.CrewResultItem
    public var id: Int { item.id }
  }

  public struct SimilarMovieResultScope: Equatable {
    public let page: Int
    public let totalPage: Int
    public let totalResult: Int
    public let resultList: [SimilarMovieResultItemScope]

    init(
      page: Int = .zero,
      totalPage: Int = .zero,
      totalResult: Int = .zero,
      resultList: [SimilarMovieResultItemScope] = [])
    {
      self.page = page
      self.totalPage = totalPage
      self.totalResult = totalResult
      self.resultList = resultList
    }
  }

  public struct SimilarMovieResultItemScope: Equatable, Identifiable {
    public let imageURL: String
    public let item: MovieDetailDomain.Response.SimilarMovieResultItem
    public var id: Int { item.id }
  }

  public struct RecommendedMovieResultScope: Equatable {
    public let page: Int
    public let totalPage: Int
    public let totalResult: Int
    public let resultList: [RecommendedMovieResultItemScope]

    init(
      page: Int = .zero,
      totalPage: Int = .zero,
      totalResult: Int = .zero,
      resultList: [RecommendedMovieResultItemScope] = [])
    {
      self.page = page
      self.totalPage = totalPage
      self.totalResult = totalResult
      self.resultList = resultList
    }
  }

  public struct RecommendedMovieResultItemScope: Equatable, Identifiable {
    public let imageURL: String
    public let item: MovieDetailDomain.Response.RecommendedMovieResultItem
    public var id: Int { item.id }
  }
}

extension MovieDetailStore.State { }

// MARK: - MovieDetailStore.Action

extension MovieDetailStore {
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case getMovieDetail

    case onSelectReview(MovieDetailDomain.Response.MovieReviewResult)
    case onSelectCast(MovieDetailStore.MovieCreditResultScope)
    case onSelectCrew(MovieDetailStore.MovieCreditResultScope)
    case onSelectSimilarMovie(MovieDetailDomain.Response.SimilarMovieResult)
    case onSelectRecommendedMovie(MovieDetailDomain.Response.RecommendedMovieResult)

    case fetchMovieCard(Result<MovieCardResultScope, CompositeErrorDomain>)
    case fetchMovieReview(Result<MovieDetailDomain.Response.MovieReviewResult, CompositeErrorDomain>)
    case fetchMovieCredit(Result<MovieCreditResultScope, CompositeErrorDomain>)
    case fetchSimilarMovie(Result<SimilarMovieResultScope, CompositeErrorDomain>)
    case fetchRecommendedMovie(Result<RecommendedMovieResultScope, CompositeErrorDomain>)

    case throwError(CompositeErrorDomain)
  }
}

// MARK: - MovieDetailStore.CancelID

extension MovieDetailStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestMovieCard
    case requestMovieReview
    case requestMovieCredit
    case requestSimilarMovie
    case requestRecommendedMovie
  }
}

// MARK: - MovieDetailStore + Reducer

extension MovieDetailStore: Reducer {
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })

      case .getMovieDetail:
        state.fetchMovieCard.isLoading = false
        state.fetchMovieReview.isLoading = false
        state.fetchMovieCredit.isLoading = false
        state.fetchSimilarMovie.isLoading = false
        state.fetchRecommendedMovie.isLoading = false
        return .merge(
          env.movieCard(state.movieID)
            .map(Action.fetchMovieCard)
            .cancellable(pageID: pageID, id: CancelID.requestMovieCard, cancelInFlight: true),
          env.movieReview(state.movieID)
            .map(Action.fetchMovieReview)
            .cancellable(pageID: pageID, id: CancelID.requestMovieReview, cancelInFlight: true),
          env.movieCredit(state.movieID)
            .map(Action.fetchMovieCredit)
            .cancellable(pageID: pageID, id: CancelID.requestMovieCredit, cancelInFlight: true),
          env.similarMovie(state.movieID)
            .map(Action.fetchSimilarMovie)
            .cancellable(pageID: pageID, id: CancelID.requestSimilarMovie, cancelInFlight: true),
          env.recommendedMovie(state.movieID)
            .map(Action.fetchRecommendedMovie)
            .cancellable(pageID: pageID, id: CancelID.requestRecommendedMovie, cancelInFlight: true))

      case .onSelectReview(let item):
        env.routeToReview(item)
        return .none

      case .onSelectCast(let item):
        env.routeToCast(item)
        return .none

      case .onSelectCrew(let item):
        env.routeToCrew(item)
        return .none

      case .onSelectSimilarMovie(let item):
        env.routeToSimilarMovie(item)
        return .none

      case .onSelectRecommendedMovie(let item):
        env.routeToRecommendedMovie(item)
        return .none

      case .fetchMovieCard(let result):
        state.fetchMovieCard.isLoading = false
        switch result {
        case .success(let content):
          state.fetchMovieCard.value = content
          return .none
        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchMovieReview(let result):
        state.fetchMovieReview.isLoading = false
        switch result {
        case .success(let content):
          state.fetchMovieReview.value = content
          return .none
        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchMovieCredit(let result):
        state.fetchMovieCredit.isLoading = false
        switch result {
        case .success(let content):
          state.fetchMovieCredit.value = content
          return .none
        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchSimilarMovie(let result):
        state.fetchSimilarMovie.isLoading = false
        switch result {
        case .success(let content):
          state.fetchSimilarMovie.value = content
          return .none
        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

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

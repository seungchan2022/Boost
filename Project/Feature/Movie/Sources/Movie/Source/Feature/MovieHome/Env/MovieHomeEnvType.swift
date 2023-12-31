import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - MovieHomeEnvType

protocol MovieHomeEnvType {
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  var useCaseGroup: MovieSideEffectGroup { get }

  var nowPlaying: (Int)
    -> Effect<Result<MovieHomeStore.State.NowPlayScope, CompositeErrorDomain>> { get }
  var searchKeyword: (String)
    -> Effect<Result<SearchDomain.Response.KeywordResult, CompositeErrorDomain>> { get }
  var searchMovie: (String)
    -> Effect<Result<SearchDomain.Response.MovieResult, CompositeErrorDomain>> { get }
  var searchPeople: (String)
    -> Effect<Result<SearchDomain.Response.PeopleResult, CompositeErrorDomain>> { get }

  var routeToMovieDetail: (MovieDomain.MovieList.Response.ResultItem) -> Void { get }
}

extension MovieHomeEnvType {
  public var nowPlaying: (Int)
    -> Effect<Result<MovieHomeStore.State.NowPlayScope, CompositeErrorDomain>>
  {
    { pageNumber in
      .publisher {
        useCaseGroup
          .movieUseCase
          .nowPlaying(.init(locale: Locale.current, page: pageNumber))
          .map { $0.serialized(
            imageURL: useCaseGroup.configurationDomain.entity.baseURL.imageSizeURL(.medium)) }
          .mapToResult()
          .receive(on: mainQueue)
      }
    }
  }

  public var searchKeyword: (String)
    -> Effect<Result<SearchDomain.Response.KeywordResult, CompositeErrorDomain>>
  {
    { keyword in
      .publisher {
        useCaseGroup
          .searchUseCase
          .searchKeyword(.init(language: dummyLanguage, query: keyword))
          .mapToResult()
          .receive(on: mainQueue)
      }
    }
  }

  public var searchMovie: (String)
    -> Effect<Result<SearchDomain.Response.MovieResult, CompositeErrorDomain>>
  {
    { keyword in
      .publisher {
        useCaseGroup
          .searchUseCase
          .searchMovie(.init(language: dummyLanguage, query: keyword, page: 1))
          .mapToResult()
          .receive(on: mainQueue)
      }
    }
  }

  public var searchPeople: (String)
    -> Effect<Result<SearchDomain.Response.PeopleResult, CompositeErrorDomain>>
  {
    { keyword in
      .publisher {
        useCaseGroup
          .searchUseCase
          .searchPeople(.init(language: dummyLanguage, query: keyword, page: 1))
          .mapToResult()
          .receive(on: mainQueue)
      }
    }
  }
}

private let dummyLanguage = "ko-kr"
private let dummyRegion = "ko"

extension MovieDomain.MovieList.Response.NowPlay {
  func serialized(imageURL: String) -> MovieHomeStore.State.NowPlayScope {
    .init(
      totalPages: totalPages,
      totalResult: totalResult,
      page: page,
      resultList: resultList.map {
        .init(imageURL: imageURL, item: $0)
      })
  }
}

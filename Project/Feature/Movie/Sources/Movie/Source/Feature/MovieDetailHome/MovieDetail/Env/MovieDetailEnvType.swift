import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - MovieDetailEnvType

protocol MovieDetailEnvType {
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  var useCaseGroup: MovieSideEffectGroup { get }

  var movieCard: (Int)
    -> Effect<Result<MovieDetailStore.MovieCardResultScope, CompositeErrorDomain>> { get }

  var movieReview: (Int)
    -> Effect<Result<MovieDetailDomain.Response.MovieReviewResult, CompositeErrorDomain>> { get }

  var movieCredit: (Int)
    -> Effect<Result<MovieDetailStore.MovieCreditResultScope, CompositeErrorDomain>> { get }

  var similarMovie: (Int)
    -> Effect<Result<MovieDetailStore.SimilarMovieResultScope, CompositeErrorDomain>> { get }

  var recommendedMovie: (Int)
    -> Effect<Result<MovieDetailStore.RecommendedMovieResultScope, CompositeErrorDomain>> { get }

  var routeToReview: (MovieDetailDomain.Response.MovieReviewResult) -> Void { get }

  var routeToCast: (MovieDetailStore.MovieCreditResultScope) -> Void { get }

  var routeToCrew: (MovieDetailStore.MovieCreditResultScope) -> Void { get }

  var routeToSimilarMovie: (MovieDetailDomain.Response.SimilarMovieResult) -> Void { get }

  var routeToRecommendedMovie: (MovieDetailDomain.Response.RecommendedMovieResult) -> Void { get }

}

extension MovieDetailEnvType {
  public var movieCard: (Int)
    -> Effect<Result<MovieDetailStore.MovieCardResultScope, CompositeErrorDomain>>
  {
    { id in
      .publisher {
        useCaseGroup
          .movieDetailUseCase
          .movieCard(.init(id: id))
          .map { $0.serialized(
            imageURL: useCaseGroup.configurationDomain.entity.baseURL.imageSizeURL(.medium)) }
          .mapToResult()
          .receive(on: mainQueue)
      }
    }
  }

  public var movieReview: (Int)
    -> Effect<Result<MovieDetailDomain.Response.MovieReviewResult, CompositeErrorDomain>>
  {
    { id in
      .publisher {
        useCaseGroup
          .movieDetailUseCase
          .movieReview(.init(id: id))
          .mapToResult()
          .receive(on: mainQueue)
      }
    }
  }

  public var movieCredit: (Int)
    -> Effect<Result<MovieDetailStore.MovieCreditResultScope, CompositeErrorDomain>>
  {
    { id in
      .publisher {
        useCaseGroup
          .movieDetailUseCase
          .movieCredit(.init(id: id))
          .map { $0.serialized(
            imageURL: useCaseGroup.configurationDomain.entity.baseURL.imageSizeURL(.cast)) }
          .mapToResult()
          .receive(on: mainQueue)
      }
    }
  }

  public var similarMovie: (Int)
    -> Effect<Result<MovieDetailStore.SimilarMovieResultScope, CompositeErrorDomain>>
  {
    { id in
      .publisher {
        useCaseGroup
          .movieDetailUseCase
          .similarMovie(.init(id: id))
          .map { $0.serialized(
            imageURL: useCaseGroup.configurationDomain.entity.baseURL.imageSizeURL(.medium)) }
          .mapToResult()
          .receive(on: mainQueue)
      }
    }
  }

  public var recommendedMovie: (Int)
    -> Effect<Result<MovieDetailStore.RecommendedMovieResultScope, CompositeErrorDomain>>
  {
    { id in
      .publisher {
        useCaseGroup
          .movieDetailUseCase
          .recommendedMovie(.init(id: id))
          .map { $0.serialized(
            imageURL: useCaseGroup.configurationDomain.entity.baseURL.imageSizeURL(.medium)) }
          .mapToResult()
          .receive(on: mainQueue)
      }
    }
  }
}

extension MovieDetailDomain.Response.MovieCardResult {
  fileprivate func serialized(imageURL: String) -> MovieDetailStore.MovieCardResultScope {
    .init(imageURL: imageURL, item: self)
  }
}

extension MovieDetailDomain.Response.MovieCreditResult {
  fileprivate func serialized(imageURL: String) -> MovieDetailStore.MovieCreditResultScope {
    .init(
      id: id,
      castList: castList.map {
        .init(imageURL: imageURL, item: $0)
      },
      crewList: crewList.map {
        .init(imageURL: imageURL, item: $0)
      })
  }
}

extension MovieDetailDomain.Response.SimilarMovieResult {
  fileprivate func serialized(imageURL: String) -> MovieDetailStore.SimilarMovieResultScope {
    .init(
      page: page,
      totalPage: totalPage,
      totalResult: totalResult,
      resultList: resultList.map {
        .init(imageURL: imageURL, item: $0)
      })
  }
}

extension MovieDetailDomain.Response.RecommendedMovieResult {
  fileprivate func serialized(imageURL: String) -> MovieDetailStore.RecommendedMovieResultScope {
    .init(
      page: page,
      totalPage: totalPage,
      totalResult: totalResult,
      resultList: resultList.map {
        .init(imageURL: imageURL, item: $0)
      })
  }
}

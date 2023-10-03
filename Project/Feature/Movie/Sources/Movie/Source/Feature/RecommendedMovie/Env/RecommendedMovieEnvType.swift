import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - RecommendedMovieEnvType

protocol RecommendedMovieEnvType {
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
  var useCaseGroup: MovieSideEffectGroup { get }

  var recommendedMovie: (Int)
    -> Effect<Result<MovieDetailDomain.Response.RecommendedMovieResult, CompositeErrorDomain>> { get }
}

extension RecommendedMovieEnvType {
  public var recommendedMovie: (Int)
    -> Effect<Result<MovieDetailDomain.Response.RecommendedMovieResult, CompositeErrorDomain>>
  {
    { id in
      .publisher {
        useCaseGroup
          .movieDetailUseCase
          .recommendedMovie(.init(id: id))
          .mapToResult()
          .receive(on: mainQueue)
      }
    }
  }
}

import ComposableArchitecture
import Domain
import Foundation

// MARK: - MovieDetailEnvMock

struct MovieDetailEnvMock {

  let mainQueue: AnySchedulerOf<DispatchQueue>
  let useCaseGroup: MovieSideEffectGroup
}

// MARK: MovieDetailEnvType

extension MovieDetailEnvMock: MovieDetailEnvType {
  var routeToReview: (MovieDetailDomain.Response.MovieReviewResult) -> Void {
    { _ in Void() }
  }

  var routeToCast: (MovieDetailStore.MovieCreditResultScope) -> Void {
    { _ in Void() }
  }

  var routeToCrew: (MovieDetailStore.MovieCreditResultScope) -> Void {
    { _ in Void() }
  }

  var routeToSimilarMovie: (MovieDetailDomain.Response.SimilarMovieResult) -> Void {
    { _ in Void() }
  }

  var routeToRecommendedMovie: (MovieDetailDomain.Response.RecommendedMovieResult) -> Void {
    { _ in Void() }
  }
}

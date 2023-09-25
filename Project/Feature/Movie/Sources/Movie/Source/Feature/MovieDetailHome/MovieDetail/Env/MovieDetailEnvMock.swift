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
}

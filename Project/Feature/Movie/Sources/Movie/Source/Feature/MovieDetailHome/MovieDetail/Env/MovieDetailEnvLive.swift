import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator
import URLEncodedForm

// MARK: - MovieDetailEnvLive

struct MovieDetailEnvLive {

  let mainQueue: AnySchedulerOf<DispatchQueue>
  let useCaseGroup: MovieSideEffectGroup
  let navigator: LinkNavigatorProtocol

  init(
    mainQueue: AnySchedulerOf<DispatchQueue> = .main,
    useCaseGroup: MovieSideEffectGroup,
    navigator: LinkNavigatorProtocol)
  {
    self.mainQueue = mainQueue
    self.useCaseGroup = useCaseGroup
    self.navigator = navigator
  }
}

// MARK: MovieDetailEnvType

extension MovieDetailEnvLive: MovieDetailEnvType {
  var routeToReview: (MovieDetailDomain.Response.MovieReviewResult) -> Void {
    { item in
      navigator.backOrNext(
        linkItem: .init(
          path: Link.Movie.Path.review.rawValue,
          items: item.encoded()),
        isAnimated: true)
    }
  }

  var routeToCast: (MovieDetailStore.MovieCreditResultScope) -> Void {
    { item in
      navigator.backOrNext(
        linkItem: .init(
          path: Link.Movie.Path.cast.rawValue,
          items: item.encoded()),
        isAnimated: true)
    }
  }

  var routeToCrew: (MovieDetailStore.MovieCreditResultScope) -> Void {
    { item in
      navigator.backOrNext(
        linkItem: .init(
          path: Link.Movie.Path.crew.rawValue,
          items: item.encoded()),
        isAnimated: true)
    }
  }

  var routeToSimilarMovie: (MovieDetailDomain.Response.SimilarMovieResult) -> Void {
    { item in
      navigator.backOrNext(
        linkItem: .init(
          path: Link.Movie.Path.similarMovie.rawValue,
          items: item.encoded()),
        isAnimated: true)
    }
  }

  var routeToRecommendedMovie: (MovieDetailDomain.Response.RecommendedMovieResult) -> Void {
    { item in
      navigator.backOrNext(
        linkItem: .init(
          path: Link.Movie.Path.recommendedMovie.rawValue,
          items: item.encoded()),
        isAnimated: true)
    }
  }
}

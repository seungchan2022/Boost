import ComposableArchitecture
import Foundation
import LinkNavigator
import Domain
import URLEncodedForm
import Architecture

// MARK: - MovieHomeLive

struct MovieHomeLive {
  
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let useCaseGroup: MovieSideEffectGroup
  let navigator: LinkNavigatorURLEncodedItemProtocol
  
  init(
    mainQueue: AnySchedulerOf<DispatchQueue> = .main,
    useCaseGroup: MovieSideEffectGroup,
    navigator: LinkNavigatorURLEncodedItemProtocol)
  {
    self.mainQueue = mainQueue
    self.useCaseGroup = useCaseGroup
    self.navigator = navigator
  }
}

// MARK: MovieHomeEnvType

extension MovieHomeLive: MovieHomeEnvType {
  var routeToMovieDetail: (MovieDomain.MovieList.Response.ResultItem) -> Void {
    { item in
      navigator.backOrNext(
        linkItem: .init(
          path: Link.Movie.Path.movieDetail.rawValue,
          items: item.encodeString()),
        isAnimated: true)
    }
  }
}

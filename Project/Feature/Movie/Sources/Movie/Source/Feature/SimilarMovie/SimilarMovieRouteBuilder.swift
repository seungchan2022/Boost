import Architecture
import Domain
import LinkNavigator
import URLEncodedForm

struct SimilarMovieRouteBuilder<RootNavigator: LinkNavigatorURLEncodedItemProtocol & LinkNavigatorFindLocationUsable> {

  static func generate() -> RouteBuilderOf<RootNavigator, LinkNavigatorURLEncodedItemProtocol.ItemValue> {
    let matchPath = Link.Movie.Path.similarMovie.rawValue

    return .init(matchPath: matchPath) { navigator, item, dependency -> RouteViewController? in
      guard
        let env: MovieSideEffectGroup = dependency.resolve(),
        let query: MovieDetailDomain.Response.MovieCardResult = item.decodedObject()
      else {
        print("Either env or query is nil")
        return .none
      }

      print("Query ID:", query.id)
//      else { return .none }

      return WrappingController(matchPath: matchPath) {
        SimilarMoviePage(store: .init(
          initialState: SimilarMovieStore.State(movieID: query.id),
          reducer: {
            SimilarMovieStore(env: SimilarMovieEnvLive(
              useCaseGroup: env,
              navigator: navigator))
          }))
      }
    }
  }
}

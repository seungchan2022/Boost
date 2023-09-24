import Architecture
import LinkNavigator

struct MovieHomeRouteBuilder<RootNavigator: LinkNavigatorURLEncodedItemProtocol & LinkNavigatorFindLocationUsable> {

  static func generate() -> RouteBuilderOf<RootNavigator, LinkNavigatorURLEncodedItemProtocol.ItemValue> {
    let matchPath = Link.Movie.Path.home.rawValue

    return .init(matchPath: matchPath) { navigator, _, dependency -> RouteViewController? in
      guard let env: MovieSideEffectGroup = dependency.resolve() else { return .none }

      return WrappingController(matchPath: matchPath) {
        MovieHomePage(store: .init(
          initialState: MovieHomeStore.State(),
          reducer: {
            MovieHomeStore(env: MovieHomeEnvLive(
              useCaseGroup: env,
              navigator: navigator))
          }))
      }
    }
  }
}

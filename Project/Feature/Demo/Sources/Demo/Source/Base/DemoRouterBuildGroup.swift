import Architecture
import LinkNavigator

public struct DemoRouterBuildGroup<RootNavigator: LinkNavigatorURLEncodedItemProtocol & LinkNavigatorFindLocationUsable> {
  public init() { }
}

extension DemoRouterBuildGroup {
  public static var realease: [RouteBuilderOf<RootNavigator, LinkNavigatorURLEncodedItemProtocol.ItemValue>] {
    [
      Step1Router.generate(),
      Step2Router.generate()
    ]
  }
}

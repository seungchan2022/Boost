import Foundation
import LinkNavigator

struct MovieDetailLive {
  
  let useCaseGroup: MovieSideEffectGroup
  let navigator: LinkNavigatorURLEncodedItemProtocol
}

extension MovieDetailLive: MovieDetailEnvType {
}

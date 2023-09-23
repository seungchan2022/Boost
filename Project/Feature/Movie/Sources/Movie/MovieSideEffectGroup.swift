import Architecture
import LinkNavigator
import Domain

public protocol MovieSideEffectGroup: DependencyType {
  var configurationDomain: ConfigurationDomain { get }
  var movieUseCase: MovieUseCase { get }
  var searchUseCase: SearchUseCase { get }
  var movieDetailUseCase: MovieDetailUseCase { get }
}

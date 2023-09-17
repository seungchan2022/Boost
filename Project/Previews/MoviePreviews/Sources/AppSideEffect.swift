import Architecture
import LinkNavigator
import Movie
import Domain

struct AppSideEffect {
  init(
    configurationDomain: ConfigurationDomain,
   movieUseCase: MovieUseCase)
  {
    self.configurationDomain = configurationDomain
    self.movieUseCase = movieUseCase
  }
  
  let configurationDomain: ConfigurationDomain
  let movieUseCase: MovieUseCase
}

extension AppSideEffect: MovieSideEffectGroup {
}

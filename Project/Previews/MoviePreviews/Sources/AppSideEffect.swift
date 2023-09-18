import Architecture
import LinkNavigator
import Movie
import Domain

struct AppSideEffect {
  init(
    configurationDomain: ConfigurationDomain,
   movieUseCase: MovieUseCase,
    searchUseCase: SearchUseCase)
  {
    self.configurationDomain = configurationDomain
    self.movieUseCase = movieUseCase
    self.searchUseCase = searchUseCase
  }
  
  let configurationDomain: ConfigurationDomain
  let movieUseCase: MovieUseCase
  let searchUseCase: SearchUseCase
}

extension AppSideEffect: MovieSideEffectGroup {
}

import Foundation
import Combine

public protocol MovieUseCase {
  var nowPlaying: (MovieDomain.MovieList.Request.NowPlay)
    -> AnyPublisher<MovieDomain.MovieList.Response.NowPlay, CompositeErrorDomain> { get }
}



//https://api.themoviedb.org/3/movie/now_playing?api_key=1d9b898a212ea52e283351e521e17871&language=ko-US&page=1&region=KR

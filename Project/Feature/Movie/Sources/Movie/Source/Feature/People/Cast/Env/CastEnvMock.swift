import ComposableArchitecture
import Domain
import Foundation

// MARK: - CastEnvMock

struct CastEnvMock {

  let mainQueue: AnySchedulerOf<DispatchQueue>
  let useCaseGroup: MovieSideEffectGroup
}

// MARK: CastEnvType

extension CastEnvMock: CastEnvType { }

import Foundation
import ComposableArchitecture

public struct MovieDetailStore {
  let pageID: String
  let env: MovieDetailEnvType
  init(pageID: String = UUID().uuidString, env: MovieDetailEnvType) {
    self.pageID = pageID
    self.env = env
  }
}

extension MovieDetailStore {
  public struct State: Equatable {

  }
}

extension MovieDetailStore.State {
  
}

extension MovieDetailStore {
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown
  }
}

extension MovieDetailStore: Reducer {
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .teardown:
        return .none
      }
    }
  }
}

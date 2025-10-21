import Foundation

@Observable
public final class Store<State: Equatable & Sendable, Action: Sendable> {
    @Published private(set) var state: State
    let reducer: Reducer<State, Action>
    private let queue = DispatchQueue(
        label: "store.queue",
        qos: .userInitiated,
        attributes: .concurrent
    )
    
    var statePublisher: Published<State>.Publisher {
        $state
    }
    
    public init(initialState: State, reducer: Reducer<State, Action>) {
        self.state = initialState
        self.reducer = reducer
    }
    
    private func updateState(_ newState: State) {
        state = newState
    }
    
    public func send(_ action: Action) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            
            let oldState = self.state
            self.reducer.reduce(&self.state, action, self.send)
        }
    }
}

public struct Reducer<State, Action> {
    let reduce: (inout State, Action, @escaping (Action) -> Void) -> Void
    
    public init(
        reduce: @escaping (inout State, Action, @escaping (Action) -> Void) -> Void
    ) {
        self.reduce = reduce
    }
}

extension Store: @unchecked Sendable {}

//
//  AppState.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final public class Store<State: FluxState>: ObservableObject {
    @Published public var state: State

    private var dispatchFunction: DispatchFunction!
    private let reducer: Reducer<State>
    
    public init(reducer: @escaping Reducer<State>,
                middleware: [Middleware<State>] = [],
                state: State) {
        self.reducer = reducer
        self.state = state
        
        var middleware = middleware
        middleware.append(asyncActionsMiddleware)
        self.dispatchFunction = middleware
            .reversed()
            .reduce(
                { [unowned self] action in
                    self._dispatch(action: action) },
                { dispatchFunction, middleware in
                    let dispatch: (Action) -> Void = { [weak self] in self?.dispatch(action: $0) }
                    let getState = { [weak self] in self?.state }
                    return middleware(dispatch, getState)(dispatchFunction)
            })
    }

    public func dispatch(action: Action) {
        print("Dispatching action:")
        debugPrint(action)
        
//        if Thread.isMainThread {
//            self.dispatchFunction(action)
//            return
//        }
        
        DispatchQueue.main.async {
            self.dispatchFunction(action)
        }
    }
    
    private func _dispatch(action: Action) {
        state = reducer(state, action)
        print("State:")
        debugPrint(state)
        print("-- End State")
    }
}

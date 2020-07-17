//
//  Reducer.swift
//  SimpleScheme
//
//  Created by Bradley Barrows on 7/14/20.
//  Copyright © 2020 Bradley Barrows. All rights reserved.
//

import Foundation

func SimpleSchemeReducer(state: SimpleSchemeState, action: Action) -> SimpleSchemeState {
    switch action {
    case let action as SimpleSchemeActions.setConsoleOutput:
        state.consoleOutput = action.output
    case let action as SimpleSchemeActions.setIsPipeCreated:
        state.isPipeCreated = action.isCreated
    case let action as SimpleSchemeActions.setCurrentFile:
        state.currentFile = action.file
    case let action as SimpleSchemeActions.setFileToRename:
        state.fileToRename = action.file
    case let action as SimpleSchemeActions.setCurrentDirectory:
        state.currentDirectory = action.directory
    default:
        break
    }
    
    return state
}

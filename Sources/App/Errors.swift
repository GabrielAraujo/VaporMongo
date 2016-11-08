//
//  Errors.swift
//  VaporMongo
//
//  Created by Gabriel Araujo on 08/11/16.
//
//

import Foundation
import Vapor

enum Errors : Error {
    case generic
    case invalidResp
    
    case missingUsernameOrPassword
    
    static let ids = [
        generic : 0,
        invalidResp : 1,
        missingUsernameOrPassword: 10
    ]
    
    static let messages = [
        generic : "Generic error!",
        invalidResp : "The response was invalid, try again!",
        missingUsernameOrPassword: "Missing username or password"
    ]
    
    func getId() -> Int {
        guard let id = Errors.ids[self] else {
            return Errors.ids[Errors.generic]!
        }
        return id
    }
    
    func getMessage() -> String {
        guard let msg = Errors.messages[self] else {
            return Errors.messages[Errors.generic]!
        }
        return msg
    }
}

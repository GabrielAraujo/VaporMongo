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
    case invalidCredentials
    case missingUsernameOrPassword
    case missingUsernameOrPasswordOrAccessToken
    case invalidUser
    case userNotFound
    
    case registrationPerIdNotFound
    
    case invalidToken
    
    case notAuthorized
    
    case missingToken
    
    static let ids = [
        generic : 0,
        invalidResp : 1,
        invalidCredentials: 5,
        missingUsernameOrPassword: 10,
        missingUsernameOrPasswordOrAccessToken: 11,
        invalidUser: 12,
        userNotFound: 13,
        invalidToken: 20,
        registrationPerIdNotFound: 40,
        notAuthorized: 50,
        missingToken: 60
    ]
    
    static let messages = [
        generic : "Generic error!",
        invalidResp : "The response was invalid, try again!",
        invalidCredentials : "Invalid credentials.",
        missingUsernameOrPassword: "Missing username or password",
        missingUsernameOrPasswordOrAccessToken: "Missing username or password or device token",
        invalidUser : "Invalid user.",
        userNotFound : "User not found.",
        invalidToken: "Invalid token.",
        registrationPerIdNotFound: "Registration per ID was not implemented.",
        notAuthorized: "You are not authorized for this location.",
        missingToken: "The token is missing in header Authorization!"
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

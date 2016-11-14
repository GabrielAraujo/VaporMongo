//
//  User.swift
//  MongoTest
//
//  Created by Gabriel Araujo on 05/11/16.
//
//

import Vapor
import Fluent
import Foundation
import VaporJWT

final class User: Model {
    var id: Node?
    var data: Node?
    var username:String?
    var password: String?
    var accessToken:String?
    var exists: Bool = false
    
    enum Error: Swift.Error {
        case userNotFound
        case registerNotSupported
        case unsupportedCredentials
    }
    
    init(id: Node) {
        self.id = id
    }
    
    init(data: Node) {
        self.data = data
    }
    
    init(node: Node, in context: Context) throws {
        self.id = nil
        self.data = try node.extract("data")
        self.username = try node.extract("username")
        self.password = try node.extract("password")
        self.accessToken = try node.extract("access_token")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "data": data,
            "username": username,
            "password": password,
            "access_token": accessToken
            ])
    }
    
    static func prepare(_ database: Database) throws {
        //
    }
    
    static func revert(_ database: Database) throws {
        //
    }
}

import Auth

extension User: Auth.User {
    static func authenticate(credentials: Credentials) throws -> Auth.User {
        let user: User?
        
        switch credentials {
        //case let id as Identifier:
        case _ as Identifier:
            //user = try User.find(id.id)
            throw Errors.registrationPerIdNotFound
            //throw Abort.custom(status: .badRequest, message: "Registration per id not implemented!")
        case let accessToken as AccessToken:
            //Queries for the user
            user = try User.query().filter("access_token", accessToken.string).first()
            //Validate if the user was fetched
            guard let u = user else {
                //If not throw error
                throw Errors.userNotFound
                //throw Abort.custom(status: .badRequest, message: "User not found")
            }
            
            guard
                let accessToken = u.accessToken,
                let username = u.username,
                let password = u.password
                else {
                    throw Errors.missingUsernameOrPasswordOrAccessToken
                    //throw Abort.custom(status: .badRequest, message: "User found - Missing info")
            }
            
            //Create a token based with the one stored in the db
            let jwt = try JWT(token: accessToken)
            if try jwt.verifySignatureWith(HS256(key: "\(username)\(password)")) {
                return u
            }else{
                throw Errors.invalidToken
                //throw Abort.custom(status: .badRequest, message: "Invalid token")
            }
        case let apiKey as APIKey:
            user = try User.query().filter("username", apiKey.id).filter("password", apiKey.secret).first()
            
            //Validate if the user was fetched
            guard var u = user else {
                //If not throw error
                throw Errors.userNotFound
                //throw Abort.custom(status: .badRequest, message: "User not found")
            }
            
            guard
                let username = u.username,
                let password = u.password
                else {
                    throw Errors.missingUsernameOrPassword
            }
            
            let jwt = try JWT(payload: Node([ExpirationTimeClaim(60, leeway: 10)]), signer: HS256(key: "\(username)\(password)"))
            let token = try jwt.createToken()
            
            u.accessToken = token
            
            try u.save()
            
            return u
        default:
            throw Errors.invalidCredentials
            //throw Abort.custom(status: .badRequest, message: "Invalid credentials.")
        }
    }
    
    
    static func register(credentials: Credentials) throws -> Auth.User {
        let user: User?
        
        switch credentials {
        case _ as Identifier:
            throw Abort.custom(status: .badRequest, message: "Registration per id not implemented!")
        case _ as AccessToken:
            throw Abort.custom(status: .badRequest, message: "Registration per access_token not implemented!")
        case let apiKey as APIKey:
            user = try User.query().filter("email", apiKey.id).filter("password", apiKey.secret).first()
        default:
            throw Errors.invalidCredentials
            //throw Abort.custom(status: .badRequest, message: "Invalid credentials.")
        }
        
        guard let u = user else {
            throw Errors.userNotFound
            //throw Abort.custom(status: .badRequest, message: "User not found")
        }
        
        return u
        
        //throw Abort.custom(status: .badRequest, message: "Register not supported.")
    }
}

import HTTP

extension Request {
    func authUser() throws -> User {
        guard let user = try auth.user() as? User else {
            throw Errors.invalidUser
            //throw Abort.custom(status: .badRequest, message: "Invalid user type.")
        }
        
        return user
    }
}

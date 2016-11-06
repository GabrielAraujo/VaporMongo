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

final class User: Model {
    var id: Node?
    var data: Node?
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
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "data": data
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
        case let id as Identifier:
            user = try User.find(id.id)
        case let accessToken as AccessToken:
            user = try User.query().filter("access_token", accessToken.string).first()
        case let apiKey as APIKey:
            user = try User.query().filter("email", apiKey.id).filter("password", apiKey.secret).first()
        default:
            throw Abort.custom(status: .badRequest, message: "Invalid credentials.")
        }
        
        guard let u = user else {
            throw Abort.custom(status: .badRequest, message: "User not found")
        }
        
        return u
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
            throw Abort.custom(status: .badRequest, message: "Invalid credentials.")
        }
        
        guard let u = user else {
            throw Abort.custom(status: .badRequest, message: "User not found")
        }
        
        return u
        
        //throw Abort.custom(status: .badRequest, message: "Register not supported.")
    }
}

import HTTP

extension Request {
    func user() throws -> User {
        guard let user = try auth.user() as? User else {
            throw Abort.custom(status: .badRequest, message: "Invalid user type.")
        }
        
        return user
    }
}

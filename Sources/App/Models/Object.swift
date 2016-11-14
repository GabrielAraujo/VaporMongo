//
//  Object.swift
//  VaporMongo
//
//  Created by Gabriel Araujo on 14/11/16.
//
//

import Vapor
import Fluent
import Foundation

final class Object: Model {
    var id: Node?
    var type: String?
    var data: Node?
    var exists: Bool = false
    
    init(type:String, data: Node) {
        self.id = UUID().uuidString.makeNode()
        self.type = type
        self.data = data
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        type = try node.extract("type")
        data = try node.extract("data")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "type": type,
            "data" : data
            ])
    }
}

extension Object {
    /**
     This will automatically fetch from database, using example here to load
     automatically for example. Remove on real models.
     */
    public convenience init?(from type: String, data: Node) throws {
        self.init(type: type, data: data)
    }
}

extension Object: Preparation {
    static func prepare(_ database: Database) throws {
        //
    }
    
    static func revert(_ database: Database) throws {
        //
    }
}

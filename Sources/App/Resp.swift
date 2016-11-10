//
//  Resp.swift
//  VaporMongo
//
//  Created by Gabriel Araujo on 07/11/16.
//
//

import Foundation
import Vapor
import HTTP

struct Resp : ResponseRepresentable {
    let success: Bool
    let error: Int?
    let message: String
    let data: Node?
    
    init(success:Bool, error:Int?, message:String, data:Node?) {
        self.success = success
        self.error = error
        self.message = message
        self.data = data
    }
    
    //Success
    init(data:Node) {
        self.success = true
        self.error = nil
        self.message = "Success!"
        self.data = data
    }
    
    init(message:String) {
        self.success = true
        self.error = nil
        self.message = message
        self.data = nil
    }
    
    //Error
    init(error:Errors) {
        self.success = false
        self.error = error.getId()
        self.message = error.getMessage()
        self.data = nil
    }

    func makeResponse() throws -> Response {
        let json = try JSON(node:
          [
            "success": success,
            "error": error,
            "message": message,
            "data": data
          ]
        )
        return try json.makeResponse()
    }
}

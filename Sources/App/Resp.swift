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

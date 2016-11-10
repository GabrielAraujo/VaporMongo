//
//  ErrorsMiddleware.swift
//  VaporMongo
//
//  Created by Gabriel Araujo on 09/11/16.
//
//

import Foundation
import Vapor
import HTTP

final class ErrorsMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        do {
            return try next.respond(to: request)
        } catch let e as Errors {
            let json = try JSON(node: [
                "success": false,
                "error": e.getId(),
                "message":  e.getMessage(),
                "data":nil
                ])
            let data = try json.makeBytes()
            let resp = Response(status: .badRequest, body: .data(data))
            resp.headers = ["Content-Type":"application/json"]
            return resp
        } catch  _ {
            let json = try JSON(node: [
                "success": false,
                "error": Errors.generic.getId(),
                "message":  Errors.generic.getMessage(),
                "data":nil
                ])
            let data = try json.makeBytes()
            let resp = Response(status: .badRequest, body: .data(data))
            resp.headers = ["Content-Type":"application/json"]
            return resp
        }
    }
}

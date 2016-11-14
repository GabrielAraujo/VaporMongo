//
//  ObjectController.swift
//  VaporMongo
//
//  Created by Gabriel Araujo on 14/11/16.
//
//

import Vapor
import HTTP

final class ObjectController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        var resp:Resp!
        do {
            guard let token = request.auth.header?.bearer else {
                resp = Resp(error: Errors.missingToken)
                print("Missing token")
                return resp
            }
            
            try request.auth.login(token)
            
            let objects = try Object.all().makeNode().converted(to: JSON.self)
            resp = try Resp(data: Node(node: objects))
        }catch let e as Errors {
            resp = Resp(error: e)
        }catch  _ {
            resp = Resp(error: Errors.generic)
            print("Unhandled error")
        }
        
        guard let r = resp else {
            resp = Resp(error: Errors.invalidResp)
            print("Unhandled error")
            return resp
        }
        
        return r
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var resp:Resp!
        do {
            guard let token = request.auth.header?.bearer else {
                resp = Resp(error: Errors.missingToken)
                print("Missing token")
                return resp
            }
            
            try request.auth.login(token)
            
            var todo = try request.object()
            try todo.save()
            
            resp = try Resp(data: Node(node: todo))
        }catch let e as Errors {
            resp = Resp(error: e)
        }catch  _ {
            resp = Resp(error: Errors.generic)
            print("Unhandled error")
        }
        
        guard let r = resp else {
            resp = Resp(error: Errors.invalidResp)
            print("Unhandled error")
            return resp
        }
        
        return r
    }
    
    func show(request: Request, object: Object) throws -> ResponseRepresentable {
        var resp:Resp!
        do {
            guard let token = request.auth.header?.bearer else {
                resp = Resp(error: Errors.missingToken)
                print("Missing token")
                return resp
            }
            
            try request.auth.login(token)
            
            resp = try Resp(data: Node(node: object))
        }catch let e as Errors {
            resp = Resp(error: e)
        }catch  _ {
            resp = Resp(error: Errors.generic)
            print("Unhandled error")
        }
        
        guard let r = resp else {
            resp = Resp(error: Errors.invalidResp)
            print("Unhandled error")
            return resp
        }
        
        return r
    }
    
    func delete(request: Request, object: Object) throws -> ResponseRepresentable {
        var resp:Resp!
        do {
            guard let token = request.auth.header?.bearer else {
                resp = Resp(error: Errors.missingToken)
                print("Missing token")
                return resp
            }
            
            try request.auth.login(token)
            
            let id = object.id
            
            try object.delete()
            
            resp = Resp(message: "Deleted ID: \(id!)")
        }catch let e as Errors {
            resp = Resp(error: e)
        }catch  _ {
            resp = Resp(error: Errors.generic)
            print("Unhandled error")
        }
        
        guard let r = resp else {
            resp = Resp(error: Errors.invalidResp)
            print("Unhandled error")
            return resp
        }
        
        return r
    }
    
    func clear(request: Request) throws -> ResponseRepresentable {
        var resp:Resp!
        do {
            guard let token = request.auth.header?.bearer else {
                resp = Resp(error: Errors.missingToken)
                print("Missing token")
                return resp
            }
            
            try request.auth.login(token)
            
            try Object.query().delete()
            
            resp = Resp(message: "Deleted all from objects")
        }catch let e as Errors {
            resp = Resp(error: e)
        }catch  _ {
            resp = Resp(error: Errors.generic)
            print("Unhandled error")
        }
        
        guard let r = resp else {
            resp = Resp(error: Errors.invalidResp)
            print("Unhandled error")
            return resp
        }
        
        return r
    }
    
    func update(request: Request, object: Object) throws -> ResponseRepresentable {
        var resp:Resp!
        do {
            guard let token = request.auth.header?.bearer else {
                resp = Resp(error: Errors.missingToken)
                print("Missing token")
                return resp
            }
            
            try request.auth.login(token)
            
            let new = try request.object()
            var object = object
            
            //Update the attributes here
            object.type = new.type
            object.data = new.data
            object.exists = new.exists
            
            try object.save()
            
            resp = try Resp(data: Node(node: object))
        }catch let e as Errors {
            resp = Resp(error: e)
        }catch  _ {
            resp = Resp(error: Errors.generic)
            print("Unhandled error")
        }
        
        guard let r = resp else {
            resp = Resp(error: Errors.invalidResp)
            print("Unhandled error")
            return resp
        }
        
        return r
    }
    
    func replace(request: Request, object: Object) throws -> ResponseRepresentable {
        var resp:Resp!
        do {
            guard let token = request.auth.header?.bearer else {
                resp = Resp(error: Errors.missingToken)
                print("Missing token")
                return resp
            }
            
            try request.auth.login(token)
            
            try object.delete()
            var todo = try request.object()
            try todo.save()
            
            resp = try Resp(data: Node(node: todo))
        }catch let e as Errors {
            resp = Resp(error: e)
        }catch  _ {
            resp = Resp(error: Errors.generic)
            print("Unhandled error")
        }
        
        guard let r = resp else {
            resp = Resp(error: Errors.invalidResp)
            print("Unhandled error")
            return resp
        }
        
        return r
    }
    
    func makeResource() -> Resource<Object> {
        return Resource(
            index: index,
            store: create,
            show: show,
            replace: replace,
            modify: update,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    func object() throws -> Object {
        guard let json = json else { throw Abort.badRequest }
        return try Object(node: json)
    }
}

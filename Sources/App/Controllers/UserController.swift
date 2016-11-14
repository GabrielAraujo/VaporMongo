import Vapor
import HTTP

final class UserController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        var resp:Resp!
        do {
            guard let token = request.auth.header?.bearer else {
                resp = Resp(error: Errors.missingToken)
                print("Missing token")
                return resp
            }
            
            try request.auth.login(token)
            
            let users = try User.all().makeNode().converted(to: JSON.self)
            resp = try Resp(data: Node(node: users))
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
            
            var todo = try request.user()
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
    
    func show(request: Request, user: User) throws -> ResponseRepresentable {
        var resp:Resp!
        do {
            guard let token = request.auth.header?.bearer else {
                resp = Resp(error: Errors.missingToken)
                print("Missing token")
                return resp
            }
            
            try request.auth.login(token)
            
            resp = try Resp(data: Node(node: user))
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
    
    func delete(request: Request, user: User) throws -> ResponseRepresentable {
        var resp:Resp!
        do {
            guard let token = request.auth.header?.bearer else {
                resp = Resp(error: Errors.missingToken)
                print("Missing token")
                return resp
            }
            
            try request.auth.login(token)
            
            let id = user.id
            
            try user.delete()
            
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
            
            try User.query().delete()
            
            resp = Resp(message: "Deleted all from users")
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

    func update(request: Request, user: User) throws -> ResponseRepresentable {
        var resp:Resp!
        do {
            guard let token = request.auth.header?.bearer else {
                resp = Resp(error: Errors.missingToken)
                print("Missing token")
                return resp
            }
            
            try request.auth.login(token)
            
            let new = try request.user()
            var user = user
            
            //Update the attributes here
            user.data = new.data
            user.username = new.username
            user.password = new.password
            user.accessToken = new.accessToken
            user.exists = new.exists
            
            try user.save()
            
            resp = try Resp(data: Node(node: user))
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

    func replace(request: Request, user: User) throws -> ResponseRepresentable {
        var resp:Resp!
        do {
            guard let token = request.auth.header?.bearer else {
                resp = Resp(error: Errors.missingToken)
                print("Missing token")
                return resp
            }
            
            try request.auth.login(token)
            
            try user.delete()
            var todo = try request.user()
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

    func makeResource() -> Resource<User> {
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
    func user() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        return try User(node: json)
    }
}

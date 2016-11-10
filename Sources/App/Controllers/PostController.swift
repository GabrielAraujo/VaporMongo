import Vapor
import HTTP

final class PostController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        var resp:Resp!
        do {
            let posts = try Post.all().makeNode().converted(to: JSON.self)
            resp = try Resp(data: Node(node: posts))
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
            
            var todo = try request.post()
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

    func show(request: Request, post: Post) throws -> ResponseRepresentable {
        var resp:Resp!
        do {
            guard let token = request.auth.header?.bearer else {
                resp = Resp(error: Errors.missingToken)
                print("Missing token")
                return resp
            }
            
            try request.auth.login(token)
            
            resp = try Resp(data: Node(node: post))
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

    func delete(request: Request, post: Post) throws -> ResponseRepresentable {
        var resp:Resp!
        do {
            guard let token = request.auth.header?.bearer else {
                resp = Resp(error: Errors.missingToken)
                print("Missing token")
                return resp
            }
            
            try request.auth.login(token)
            
            let id = post.id
            
            try post.delete()
            
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
            
            try Post.query().delete()
            
            resp = Resp(message: "Deleted all from posts")
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

    func update(request: Request, post: Post) throws -> ResponseRepresentable {
        var resp:Resp!
        do {
            guard let token = request.auth.header?.bearer else {
                resp = Resp(error: Errors.missingToken)
                print("Missing token")
                return resp
            }
            
            try request.auth.login(token)
            
            let new = try request.post()
            var post = post
            
            //Update the attributes here
            post.data = new.data
            
            try post.save()
            
            resp = try Resp(data: Node(node: post))
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

    func replace(request: Request, post: Post) throws -> ResponseRepresentable {
        var resp:Resp!
        do {
            guard let token = request.auth.header?.bearer else {
                resp = Resp(error: Errors.missingToken)
                print("Missing token")
                return resp
            }
            
            try request.auth.login(token)
            
            try post.delete()
            var todo = try request.post()
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

    func makeResource() -> Resource<Post> {
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
    func post() throws -> Post {
        guard let json = json else { throw Abort.badRequest }
        return try Post(node: json)
    }
}

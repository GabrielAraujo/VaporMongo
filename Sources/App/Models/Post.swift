import Vapor
import Fluent
import Foundation

final class Post: Model {
    var id: Node?
    var data: Node?
    var exists: Bool = false
    
    init(data: Node) {
        self.id = UUID().uuidString.makeNode()
        self.data = data
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        data = try node.extract("data")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "data" : data
            ])
    }
}

extension Post {
    /**
     This will automatically fetch from database, using example here to load
     automatically for example. Remove on real models.
     */
    public convenience init?(from data: Node) throws {
        self.init(data: data)
    }
}

extension Post: Preparation {
    static func prepare(_ database: Database) throws {
        //
    }
    
    static func revert(_ database: Database) throws {
        //
    }
}

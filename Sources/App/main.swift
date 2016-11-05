import Vapor
import VaporMongo
import FluentMongo
import Auth

let auth = AuthMiddleware(user: User.self)

let drop = Droplet()
drop.preparations = [Post.self]
try drop.addProvider(VaporMongo.Provider.self)

drop.get { req in
    return try drop.view.make("welcome", [
        "message": drop.localization[req.lang, "welcome", "title"]
        ])
}

drop.get("db") { request in
    var connected = false
    if let db = drop.database?.driver as? MongoDriver {
        connected = true
    }else{
        connected = false
    }
    return try JSON(node: ["Connected": connected])
}

drop.get("version") { request in
    let appConfig = drop.config["app","version"]?.double
    guard let version = appConfig else {
        return try drop.view.make("version", [
            "version": drop.localization[request.lang, "version", "notDefined"],
            "author": drop.localization[request.lang, "version", "author"]
            ])
    }
    return try drop.view.make("version", [
        "version": version,
        "author": drop.localization[request.lang, "version", "author"]
        ])
}

drop.resource("posts", PostController())

drop.run()

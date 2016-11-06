import Vapor
import VaporMongo
import FluentMongo
import Auth
import Foundation
import Cookies

let auth = AuthMiddleware(user: User.self) { value in
    return Cookie(
        name: "auth",
        value: value,
        expires: Date().addingTimeInterval(60 * 60 * 5), // 5 hours
        secure: true,
        httpOnly: true
    )
}

let drop = Droplet()
drop.preparations = [Post.self, User.self]
drop.middleware.append(auth)
try drop.addProvider(VaporMongo.Provider.self)

drop.group("users") { users in
    
    //Any call
//    users.post("login") { req in
//        guard let key = req.auth.header?.header else {
//            throw Abort.badRequest
//        }
//        
//        let creds = AccessToken(string: key)
//        try req.auth.login(creds)
//        
//        return try JSON(node: ["message": "Logged in."])
//    }
    
    users.post("login") { req in
        guard
            let username = req.data["username"]?.string,
            let password = req.data["password"]?.string
        else {
            throw Abort.badRequest
        }
        
        let creds = APIKey(id: username, secret: password)
        try req.auth.login(creds)
        
        return try JSON(node: ["message": "Logged in.."])
    }
    
    let protect = ProtectMiddleware(error:
        Abort.custom(status: .forbidden, message: "Not authorized.")
    )
    users.group(protect) { secure in
        secure.get("secure") { req in
            return try req.user()
        }
    }
}

drop.resource("posts", PostController())

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

drop.run()

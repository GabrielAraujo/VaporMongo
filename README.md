# VaporMongo

This project uses the Swift Web framework Vapor with MongoDB to create a generic API for consuming users and objects of any type with any data without having to update the API code or the DB schema.

## MongoDB connection
In order to connect to MongoDB you must add a **mongo.json** file inside of the folder **Config/secrets**.

The mongo.json file must contain the following structure:
```json
{
    "user": "",
    "password": "",
    "database": "local",
    "port": "27017",
    "host": ""
}

```

## User
The user is used for authentication and authorization.
* The user's collection in mongo must be **users**

### User structure
```json
{
    "id" : "581f3d7d1940cb25cb1b1f2d",
    "username" : "gabriel",
    "password" : "12345678",
    "data" : {
        ...
    },
    "access_token" : "...",
}
```
* The data property can also be an array.

## Object
The object is used to manage generic objects.
* The objects's collection in mongo must be **objects**

### Object structure
```json
{
    "id" : "581f3d7d1940cb25cb1b1f2d",
    "type" : "object type, used for filtering",
    "data" : {
        ...
    }
}
```
* The data property can also be an array.

* This project also contain **posts** which is the example from Vapor example.

## Route

## Registration
The path for registration is /api/users/register and all the neccessary attributes for user like username and password should be setted.

## Authorization
Every path of the app needs the **Bearer access_token** setted in **Authorization** header of the request in order to access the data or perform an action.

The **access_token** is setted by the path /api/users/token where you should provide the **username** and **password** of the user. In a future commit the **access_token** will also be returned in the registration process.

### Help
* [Vapor Docs](http://docs.vapor.codes)
* [Postman Collection](https://www.getpostman.com/collections/2a5806fe02adb831b3b2)
* [JWT](https://github.com/siemensikkema/vapor-jwt) - By [siemensikkema](https://github.com/siemensikkema) 

## Vapor

Vapor is the most used web framework for Swift. It provides a beautifully expressive and easy to use foundation for your next website, API, or cloud project.
[Website](https://vapor.codes)

### 📖 Documentation

Visit the Vapor web framework's [documentation](http://docs.vapor.codes) for instructions on how to use this package.

### 💧 Community

Join the welcoming community of fellow Vapor developers in [slack](http://vapor.team).

### 🔧 Compatibility

Vapor package has been tested on macOS and Ubuntu.

## MongoDB
MongoDB (from humongous) is a free and open-source cross-platform document-oriented database program. Classified as a NoSQL database program, MongoDB uses JSON-like documents with schemas. MongoDB is developed by MongoDB Inc. and is free and open-source, published under a combination of the GNU Affero General Public License and the Apache License.

* [Website](https://www.mongodb.com)
* [Wikipedia](https://en.wikipedia.org/wiki/MongoDB)

### Ubuntu Installation
* [Installation](https://www.digitalocean.com/community/tutorials/how-to-install-mongodb-on-ubuntu-16-04) - By [Mateusz Papiernik](https://www.digitalocean.com/community/users/mati) 
* [RoboMongo Installation](http://stackoverflow.com/a/37184845/3831196)

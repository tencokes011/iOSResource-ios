//
//  JSONResponses.swift
//
//
//  Created by Timothy Owens on 1/13/16.
//
//
import UIKit

final class Error : ResponseObjectSerializable {
    
    var code: Int
    var response: String
    var errorId: Int
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.code = representation.valueForKey("code") as! Int
        self.response = representation.valueForKey("response") as! String
        self.errorId = representation.valueForKey("errorId") as! Int
    }
}

final class ErrorWrap : ResponseObjectSerializable {
    var error: Error?
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let e = representation.valueForKey("error") {
            self.error = Error(response: response, representation: e)
        } else {
            return nil
        }
        
    }
}

final class LoginSuccess : ResponseObjectSerializable {
    var OAuth: String?
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let s = representation.valueForKey("session") as? String {
            self.OAuth = s
        } else {
            return nil
        }
    }
}


final class Validate: ResponseObjectSerializable {
    var id: Int
    var email: String
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let id = representation.valueForKey("resourceId") as? Int {
            self.id = id
            self.email = representation.valueForKey("email") as! String
        } else {
            return nil
        }
    }
}

final class Token: ResponseObjectSerializable {
    var session: LoginSuccess?
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let s = representation.valueForKey("security") {
            self.session = LoginSuccess(response: response, representation: s)
        } else {
            return nil
        }
    }
}

final class Content : ResponseCollectionSerializable {
    let id: Int
    let name: String
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.id = representation.valueForKey("id") as! Int
        self.name = representation.valueForKey("name") as! String
    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Content] {
        var content: [Content] = []
        
        if let rep = representation as? [[String: AnyObject]] {
            for r in rep {
                if let u = Content(response: response, representation: r) {
                    content.insert(u, atIndex: 0)
                }
            }
        }
        return content
    }
}



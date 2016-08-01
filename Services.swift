//
//  Services.swift
//
//
//  Created by Timothy Owens on 4/16/15.
//
//

import UIKit
import Alamofire

enum Router: URLRequestConvertible {

    static let baseURLString = "http://yourURL.com:8280"
    
    case Login([String:AnyObject]), Validate([String:AnyObject]), Content(String)
    
    var method: Alamofire.Method {
        switch self {
        case .Login: return .POST
        case .Validate: return .POST
        case .Content: return .GET
        }
    }
    
    var path: String {
        switch self {
        case .Login: return "/Login"
        case .Validate: return "/Token"
        case .Content(let id): return "/Content/\(id)"
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseURLString)
        let mutableURLRequest = NSMutableURLRequest(URL: (URL?.URLByAppendingPathComponent(path))!)
        mutableURLRequest.HTTPMethod = method.rawValue
        mutableURLRequest.timeoutInterval = 20
        
        switch self {
        case .Login(let params):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: params).0
        case .Validate(let params):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: params).0
        default:
            return mutableURLRequest
        }
    }
}

//Global accessable session variable, uses a singleton shared instance
let session = Session.sharedInstance

class Session : NSObject  {
    
    //Singleton creation
    private class var sharedInstance: Session {
        struct Singleton {
            static let instance = Session()
        }
        return Singleton.instance
    }
    
    //Leverages the cocoapod framework Reachability. Checks to see if the device has an internet connection
    let reachability: Reachability = {
        let r = try! Reachability.reachabilityForInternetConnection()
        r.whenReachable = { reach in
            print("Internet is reachable")
        }
        r.whenUnreachable = { reach in
            print("Internat cannot be readed")
        }
        try! r.startNotifier()
        return r
    }()
    
    func checkReachability() -> Bool {
        switch self.reachability.currentReachabilityStatus {
        case .NotReachable: return false
        default: return true
        }
    }
}

struct Services {
    
    //Shared Alamofire.Manager instance thats used in each of the function calls.
    static let manager: Alamofire.Manager = {
        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.bundle.identifier")
        config.timeoutIntervalForRequest = 20
        config.timeoutIntervalForResource = 20
       return Alamofire.Manager(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }()

    static func loginUser(email: String, password: String, completion:(success: Bool, error: Error?) -> ()) {
        if session.checkReachability() {
            Alamofire.request(Router.Login(["email":email,"password":password])).debugLog().responseObject({ (r: Response<ErrorWrap, NSError>) -> Void in
                if let e = r.result.value {
                    completion(success: false, error: e.error)
                }
            }).responseObject { (r: Response<LoginSuccess,NSError>) -> Void in
                if let s = r.result.value {
                    if r.result.isSuccess {
                        session.OAuthSession = s.OAuth
                        completion(success: true, error: nil)
                    } else {
                        completion(success: false, error: Error(error: r.result.error!))
                    }
                }
            }
        }
    }
    
    static func validateSession(oauth: String, completion:(success: Token?, error: Error?) -> ()) {
        if session.checkReachability() {
            manager.request(Router.Validate(["oauth":oauth])).debugLog().responseObject({ (r: Response<ErrorWrap, NSError>) -> Void in
                if let e = r.result.value {
                    completion(success: nil, error: e.error)
                }
            }).responseObject { (r: Response<Token,NSError>) -> Void in
                if let s = r.result.value {
                    completion(success: s, error: nil)
                } else {
                    completion(success: nil, error: Error(error: r.result.error!))
                }
            }
        }
    }
    
    static func getContent(completion:(content: [Content]?, error: Error?) -> ()) {
        if session.checkReachability() {
            if let s = session.OAuthSession {
                manager.request(Router.TimeEntryContent(["token":s])).debugLog().responseObject({ (r: Response<ErrorWrap, NSError>) -> Void in
                    if let e = r.result.value {
                        completion(project: nil, error: e.error)
                    }
                }).responseCollection { (r: Response<[Content],NSError>) -> Void in
                    if let c = r.result.value {
                        completion(content: c.sort { $0.name < $1.name }, error: nil)
                    } else {
                        completion(content: nil, error: Error(error: r.result.error!))
                    }
                }
            }
        }
    }
}

/*
 
 This is how you would make those calls:
 
 Login:
 Services.loginUser(self.emailTextField.text!, password: self.passwordTextField.text!, remember: self.rememberSwitch.on.toInt()) {(success, error) -> () in
    if success {
        print("SUCCESS LOGIN")
    } else {
        //Error object should exist here
        print("Error Code: \(error?.code)")
        print("FAILED LOGIN")
    }
 }
 
 
 Validate:
 Services.validateSession(session) { (success, error) -> () in
    if let s = success {
        print("SUCCESS VALIDATION")
    } else {
        print("FAILED VALIDATION")
        print("Error Code: \(error?.code)")
    }
 }

 
 Content:
 Services.getContent { (content, error) -> () in
    if let c = content {
        for i in c {
            print("Content ID: \(i.id), Content Name: \(i.name)")
        }
     } else {
        print("Error Code: \(error?.code)")
    }
 }
 */



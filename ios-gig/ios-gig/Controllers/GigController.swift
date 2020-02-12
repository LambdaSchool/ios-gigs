//
//  GigController.swift
//  ios-gig
//
//  Created by Lambda_School_Loaner_268 on 2/12/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class GigController {
    
    // MARK: - Properties
    var bearer: Bearer?
    var baseURL: URL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    // MARK: - Methods
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        // create endpoint-specific URL
        let signUpUrl = baseURL.appendingPathComponent("users/signup")
        
        // create a URLRequest from above
        var request = URLRequest(url: signUpUrl)
        
        // modify the request for POST, add proper headers
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // encode the user model to JSON, attach as request body
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        // set up data task and handle response
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            // handle errors (like no internet connectivity, or anything that generates and Error object)
            if let error = error {
                completion(error)
                return
            }
            
            // handle client and server errors that generate non 200 status codes
            if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            // if we get this far, the response contained no errors, so sign up was successful
            completion(nil)
        }.resume()
    }
    
    func logIn(with user: User, completion: @escaping (Error?) -> ()) {
        // create endpoint-specific URL
        let logInUrl = baseURL.appendingPathComponent("users/login")
        
        // create a URLRequest from above
        var request = URLRequest(url: logInUrl)
        
        // modify the request for POST, add proper headers
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // encode the user model to JSON, attach as request body
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        // set up data task and handle response
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // handle errors (like no internet connectivity, or anything that generates and Error object)
            if let error = error {
                completion(error)
                return
            }
            
            // handle client and server errors that generate non 200 status codes
            if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            // if we get this far, the response contained no errors, so log in was successful
            completion(nil)
        }.resume()
    }
    
}

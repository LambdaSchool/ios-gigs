//
//  GigController.swift
//  Gigs
//
//  Created by macbook on 10/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class GigController {
    
    var bearer: Bearer?
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!   
    
    
    // MARK: - Sign Up URLSessionDataTask
    
        func signUp(with user: User, completion: @escaping (Error?) -> Void) {
            
            // Build the URL

            let requestURL = baseURL
                .appendingPathComponent("users")
                .appendingPathComponent("signup")
            
            // Build the request
            
            var request = URLRequest(url: requestURL)
            request.httpMethod = HTTPMethod.post.rawValue
            
            // Tell the API that the body is in JSON format
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encoder = JSONEncoder()
            
            do {
                let userJSON = try encoder.encode(user)
                request.httpBody = userJSON
            } catch {
                NSLog("Error encoding user object: \(error)")
                completion(error)
            }
            
            // Perform the request (data task)
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Handle errors
                if let error = error {
                    NSLog("Error signing up user: \(error)")
                    completion(error)
                }
                
                if let response = response as? HTTPURLResponse,
                    response.statusCode != 200 {
                    
                    let statusCodeError = NSError(domain: "com.SpencerCurtis.Gigs", code: response.statusCode, userInfo: nil)
                    completion(statusCodeError)
                }
                
                // nil means there was no error, everthing succeeded.
                completion(nil)
            }.resume()
        }
    
    
    //MARK: - Log In URLSessionDataTask
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("login")
        
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding user for sign in: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error signing in user: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                
                let statusCodeError = NSError(domain: "com.SpencerCurtis.Gigs", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                let noDataError = NSError(domain: "com.SpencerCurtis.Gigs", code: -1, userInfo: nil)
                completion(noDataError)
                return
            }
            
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
            } catch {
                NSLog("Error decoding the bearer token: \(error)")
                completion(error)
            }
            
            completion(nil)
        }.resume()
    }
    
    // create function for fetching all animal names
       
    // create function to fetch image
    
}

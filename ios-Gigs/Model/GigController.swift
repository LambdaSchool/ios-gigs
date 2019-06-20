//
//  GigController.swift
//  ios-Gigs
//
//  Created by Kat Milton on 6/19/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}

class GigController {
    
    var gigs: [Gig] = [] {
        didSet {
            
        }
    }
    
    var bearer: Bearer?
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    // Sign up
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpURL = baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    // Sign in
    
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
        let signInURL = baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
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
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    // fetch gigs
    
    func fetchGigs(completion: @escaping (Error?) -> Void) {
        guard let bearer = bearer else {
            completion(NSError())
            return
        }
        
        let allGigsUrl = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: allGigsUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(error)
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                self.gigs = try decoder.decode([Gig].self, from: data)
                completion(nil)
            } catch {
                completion(error)
                return
            }
            }.resume()
    }
    
    func createGig(with gig: Gig, completion: @escaping (Error?) -> ()) {
        
        guard let bearer = bearer else {
            completion(NSError())
            return
        }
        
        let allGigsUrl = baseURL.appendingPathComponent("gigs")
        
        var request = URLRequest(url: allGigsUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401{
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
        
            
            do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(gig)
            } catch {
                completion(error)
                return
            }
        
        
        self.gigs.append(gig)
        completion(nil)
    }.resume()
    
}
    
}

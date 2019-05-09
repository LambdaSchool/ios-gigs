//
//  GigController.swift
//  GigsHW
//
//  Created by Michael Flowers on 5/9/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class GigController {
    
    var gigs: [Gig] = []
    var bearer: Bearer? //when we initialize this class this property may not be set yet
    
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void){
        //get url in the doc/ its the endpoints
        let url = baseURL.appendingPathComponent("users/signup")
        
        //now make the urlRequest remember to set the value of the content type. BUT HOW DO WE KNOW TO DO THIS?
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //do catch the body
        do {
            let je = JSONEncoder()
          request.httpBody =  try je.encode(user)
        } catch  {
            print("Error encoding the httpBody for the signup functon: \(error.localizedDescription)")
            completion(error)
            return
        }
        
        //now we can run the data task
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                //200 means we're good so if if doesn't equal that then we have a problem
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                print("Error in the data task function of the signup functon: \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func logIn(with user: User, completion: @escaping (Error?) -> Void){
       //get url
        let url = baseURL.appendingPathComponent("users/login")
        
        //create urlRequest
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let je = JSONEncoder()
           request.httpBody = try je.encode(user)
        } catch  {
            print("Error encoding user logging in: \(error.localizedDescription)")
            completion(error)
            return
        }
        
        //now that we have the request set up we can run urlsesson
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                //we have a problem if it doesn't == 200
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                print("Error making loggin network task: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            //we do want the data because the api states that it will send us our token
            guard let data = data else {
                print("error in the data secion of the login data task: \(NSError())")
                completion(NSError())
                return
            }
            
            //decode data into our bearer
            let jd = JSONDecoder()
            do {
                //the data we get back is the bearer so we are going to put that in itself and decode itself
                self.bearer = try jd.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding the data into our bearer: \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    
}

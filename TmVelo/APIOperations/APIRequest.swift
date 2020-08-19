//
//  APIRequest.swift
//  TmVelo
//
//  Created by Cseh Krisztian on 26.07.19.
//  Copyright © 2019 Cseh Krisztian. All rights reserved.
//

import Foundation
import MapKit

// MARK: API call errors
// AppError enum that handels all possible erros
enum ApiError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
}

// Result enum to handel succes/fail
enum Result<T> {
    case success(T)
    case failure(ApiError)
}

// MARK: Api request definition
// DataRequest which sends request to given URL and convert to Decodable Object
func makeRequest<T: Codable>(with url: String, objectType: T.Type, completion: @escaping (Result<T>) -> Void) {
    
    // Create the Url
    let requestUrl = URL(string: url)!
    
    // Create session object
    let session = URLSession.shared
    
    // Create the URLRequest object using the url object
    var request = URLRequest(url: requestUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
    request.httpMethod = "POST"
    
    // Create dataTask using the session object to send data to the server
    let task = session.dataTask(with: request, completionHandler: {data, response, error in
        guard error == nil else {
            completion(Result.failure(ApiError.networkError(error!)))
            return
        }
        guard let data = data else {
            completion(Result.failure(ApiError.dataNotFound))
            return
        }
        do {
            
            // Decode JSON
            let decodedJson = try JSONDecoder().decode(T.self, from: data)
            completion(Result.success(decodedJson))
        } catch let error {
            completion(Result.failure(ApiError.jsonParsingError(error as! DecodingError)))
        }
    })
    task.resume()
}

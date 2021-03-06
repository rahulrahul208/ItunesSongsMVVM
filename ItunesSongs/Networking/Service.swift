//
//  Service.swift
//  ItunesSongs
//
//  Created by MAC on 01/04/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import Foundation


typealias jsonDictionery = [String: Any]
typealias completionHandler = (Tracks?,String?) -> ()

protocol  ServiceProtocol {
    func get(baseUrl:String, path:String, parameters:String,completion: @escaping completionHandler)
}


class Service:ServiceProtocol {

    let urlSesson = URLSession(configuration: .default)
    var dataTask:URLSessionDataTask?
    var errorMessage:String?
    
    func get(baseUrl: String, path: String, parameters: String, completion:@escaping completionHandler) {
        dataTask?.cancel()
        guard var urlComponents = URLComponents(string:baseUrl + path) else {
            errorMessage = "URL is not correct"
            return
        }
        urlComponents.query = "\(parameters)"
        guard let url = urlComponents.url else {
            errorMessage = "URL is nil"
            return
        }
        dataTask =  urlSesson.dataTask(with:url) { (data, responce, error)  in
            if let _error = error {
                self.errorMessage = "responce error \(_error.localizedDescription)"
            }else if let _data = data , let _responce = responce as? HTTPURLResponse , _responce.statusCode == 200 {
                
                if let tracks = try? JSONDecoder().decode(Tracks.self, from: _data) {
                    DispatchQueue.main.async {
                        completion(tracks, self.errorMessage)
                    }
                }
            }
        }
       dataTask?.resume()
    }
}



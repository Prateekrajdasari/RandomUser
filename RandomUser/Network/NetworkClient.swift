//
//  AppDelegate.swift
//  RandomUser
//
//  Created by Prateek Raj on 02/08/21.
//

import Foundation

protocol NetworkCLientAdapter {
    func sendRequest<T: Decodable>(withPageCount pageCount: Int,
                                   responseModel: T.Type?,
                                   completionHandler: @escaping (_ model: Decodable?, _ error: Error?) -> Void)
}

extension NetworkCLientAdapter {
    func sendRequest<T: Decodable>(withPageCount pageCount: Int,
                                   responseModel: T.Type?,
                                   completionHandler: @escaping (_ model: Decodable?, _ error: Error?) -> Void) {
        let urlSession = URLSession.shared
        guard let url = URL(string: "https://randomuser.me/api/?page=\(String(pageCount))&results=10&seed=abc")
        else { return }
        urlSession.dataTask(with: url) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                completionHandler(nil, error)
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let values = try decoder.decode(T.self, from: data)
                    completionHandler(values, nil)
                } catch {
                    completionHandler(nil, error)
                }
            }
        }.resume()
    }
}

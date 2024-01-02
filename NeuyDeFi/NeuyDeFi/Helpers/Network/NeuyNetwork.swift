//
//  NeuyNetwork.swift
//  NeuyDeFi
//
//  Created by NeuyAI on 2023-06-07.
//

enum NEUYURLS: String {
    case crypto = "https://finance.neuy.io/crypto/v1/crypto.aspx"
    case cryptocurriencies = "https://finance.neuy.io/crypto/v1/cryptocurrencies.aspx"
    case pools = "https://finance.neuy.io/crypto/v1/pools.aspx"
}

enum NEUYErrors: Error {
    case badURL
    case failedConnection
    case failedParsing
    case badData
}

import UIKit

class NeuyNetwork: NSObject {

    //YOU APIKEY
    let apiKey = "[YOUR APIKEY]"

    func networkConnection(urlString: String, completion : @escaping (Swift.Result<[String:Any],NEUYErrors>) -> Void) {

        var finalUrl = urlString
        if urlString.contains("?") {
            finalUrl = finalUrl + "&apiKey=" + apiKey
        } else {
            finalUrl = finalUrl + "?apiKey=" + apiKey
        }

        guard let serviceURL = URL.init(string: finalUrl ) else {
            completion(.failure(NEUYErrors.badURL))
            return
        }
        let queueOperation = OperationQueue()
        queueOperation.qualityOfService = .userInitiated
        let defaultSession = URLSession.init(configuration: .ephemeral, delegate: nil, delegateQueue: queueOperation)
        var dataTask: URLSessionTask?
        let request = URLRequest(url: serviceURL)
        
        dataTask = defaultSession.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let output = data {
                do {
                    let parseData = try JSONSerialization.jsonObject(with: output, options: []) as! [String:Any]
                    DispatchQueue.main.async {
                        completion(.success(parseData))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(NEUYErrors.failedParsing))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(NEUYErrors.badData))
                }
            }
        })
        dataTask?.resume()
    }
}

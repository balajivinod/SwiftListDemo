//
//  NetworkManager.swift
//  SwiftListDemo
//
//  Created by Balasubramanian Thangavel on 03/02/24.
//

import Foundation

enum RequestError: Error {
    case invalidURL
    case failed(description: String)
    case noData
    case decode(description: String)
    case unExpectedStatusCode(description: String)
    
    var customDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No Data Found"
        case .decode(let description):
            return "Decoding Error: \(description)"
        case .failed(let description):
            return "Request Failed: \(description)"
        case .unExpectedStatusCode(let description):
            return "Unknown Error: \(description)"
        default:
            return "Unknown Error"
        }
    }
}

enum RequestType: String {
    case get = "GET"
    case post = "POST"
}

protocol Request {
    var host: String { get }
    var scheme: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var params: [String: Any] { get }
    var requestType: RequestType { get }
}

extension Request {
    var host: String {
        "jsonplaceholder.typicode.com"
    }

    var scheme: String {
        "https"
    }

    var headers: [String: String] {
        [:]
    }
    
    var params: [String: Any] {
        [:]
    }

    var requestType: RequestType {
        .get
    }
    
    func createURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path

        guard let url = components.url else {
            throw RequestError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        
        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }
        
        return urlRequest
    }
}

protocol RequestHandlerProtocol {
    func sendRequest(request: Request) async throws -> Data
}

struct RequestHandler: RequestHandlerProtocol {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func sendRequest(request: Request) async throws -> Data {
        let urlRequest = try request.createURLRequest()
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.failed(description: "Request Failed Fetching Response.")
        }
        
        switch response.statusCode {
        case 200...299:
            return data
        case 401:
            throw RequestError.unExpectedStatusCode(description: "status code: \(response.statusCode)")
        default:
            throw RequestError.unExpectedStatusCode(description: "status code: \(response.statusCode)")
        }
    }
}

protocol ResponseHandlerProtocol {
    func getResponse<T: Decodable>(from response: Data) throws -> T
}

struct ResponseHandler: ResponseHandlerProtocol {
    let decoder: JSONDecoder
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    func getResponse<T>(from response: Data) throws -> T where T : Decodable {
        do {
            return try decoder.decode(T.self, from: response)
        } catch {
            throw RequestError.decode(description: error.localizedDescription)
        }
    }
}

protocol NetworkHandlerProtocol {
    func fetch<T: Decodable>(request: Request) async throws -> T
}

class NetworkManager: NetworkHandlerProtocol {
    var requestHandlerProtocol: RequestHandlerProtocol
    var responseHandlerProtocol: ResponseHandlerProtocol
    
    init(requestHandlerProtocol: RequestHandlerProtocol = RequestHandler(), responseHandlerProtocol: ResponseHandlerProtocol = ResponseHandler()) {
        self.requestHandlerProtocol = requestHandlerProtocol
        self.responseHandlerProtocol = responseHandlerProtocol
    }
    
    func fetch<T>(request: Request) async throws -> T where T: Decodable {
        let data = try await requestHandlerProtocol.sendRequest(request: request)
        return try responseHandlerProtocol.getResponse(from: data)
    }
}





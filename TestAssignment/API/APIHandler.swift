//
//  APIHandler.swift
//  TestAssignment
//
//  Created by Himanshu Sharma on 15/08/25.
//

import Foundation
import Alamofire

private enum HeaderKeys: String {
    case Authorization
    case Accept
    
    var value: String {
        switch self {
        case .Authorization:
            Bundle.main.infoDictionary?["TMDBToken"] as? String ?? ""
        case .Accept:
            "application/json"
        }
    }
}

class APIHandler {
    static let shared = APIHandler()
    let baseURL:String? = Bundle.main.infoDictionary?["APIBaseURL"] as? String
    private init(){}
    
    func makeGETRequest(to endpoint: String, payload: Encodable) async throws -> Data{
        try await withCheckedThrowingContinuation{ continuation in
            if let baseUrl = baseURL {
                AF.request("\(baseUrl)\(endpoint)",method: .get,parameters: payload.toSnakeCaseDictionary(),encoding: URLEncoding.default,headers: HTTPHeaders(getHeaders())).validate().response { afResponse in
                    if let response = afResponse.response, let data = afResponse.data {
                        print(String(data:data,encoding:.utf8))
                        switch response.statusCode {
                        case 200: continuation.resume(returning: data)
                        default:
                            if let error = afResponse.error {
                                let nsError = error.asAFError?.underlyingError as NSError?
                                if nsError?.code == NSURLErrorNotConnectedToInternet {
                                    continuation.resume(throwing: NSError(domain: "TMDB", code: nsError?.code ?? -1, userInfo: [NSLocalizedDescriptionKey: "No internet connection"]))
                                    return
                                }
                                continuation.resume(throwing: error)
                                return
                            }
                        }
                    }else{
                        if let data = afResponse.data {
                            print(String(data:data,encoding:.utf8))
                        }
                        continuation.resume(throwing: NSError(domain: "TMDB", code: -1)) // Identifies if network is not available, no header received or time out
                    }
                }
            }
        }
    }
    
    private func getHeaders()->[String:String]{
        return [HeaderKeys.Authorization.rawValue:"Bearer \(HeaderKeys.Authorization.value)",HeaderKeys.Accept.rawValue:HeaderKeys.Accept.value]
    }
}

extension Encodable {
    func toSnakeCaseDictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(self),
              let jsonObject = try? JSONSerialization.jsonObject(with: data),
              let dict = jsonObject as? [String: Any] else {
            return nil
        }
        return dict
    }
}

//
//  APIManager.swift
//  AlamofireExample
//
//  Created by Teddy on 11/21/23.
//

import Alamofire
import Foundation

class APIManager {
    private let session: Session
    static let networkEnviroment: NetworkEnvironment = .dev

    static var shared: APIManager = {
        let apiManager = APIManager(session: Session())

        return apiManager
    }()

    private init(session: Session) {
        self.session = session
    }

    func call<T: Decodable>(type: T.Type, endPoint: EndPointProtocol) async throws -> T {
        let data = try await session.request(
            endPoint.url,
            method: endPoint.httpMethod,
            parameters: endPoint.parameter,
            encoding: endPoint.encoding,
            headers: endPoint.headers
        )
        .serializingData()
        .value

        let decoder = JSONDecoder()
        let result = try! decoder.decode(T.self, from: data)
        return result
    }
}

enum NetworkEnvironment {
    case dev
    case production
    case stage
}

enum Endpoint {
    case activity
}

protocol EndPointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameter: Parameters? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    var version: String { get }
}

extension Endpoint: EndPointProtocol {
    var baseURL: String {
        switch APIManager.networkEnviroment {
        case .dev: return "https://www.boredapi.com"
        case .production: return "https://www.boredapi.com"
        case .stage: return "https://www.boredapi.com"
        }
    }

    var version: String {
        return "/v1"
    }

    var path: String {
        switch self {
        case .activity:
            return "/api/activity/"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .activity:
            return .get
        }
    }

    var parameter: Parameters? {
        switch self {
        case .activity: return nil
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        case .activity:
            return ["Content-Type": "application/json",
                    "X-Requested-With": "XMLHttpRequest"]
        }
    }

    var url: URL {
        switch self {
        default:
            return URL(string: baseURL + path)!
        }
    }

    var encoding: ParameterEncoding {
        switch httpMethod {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}

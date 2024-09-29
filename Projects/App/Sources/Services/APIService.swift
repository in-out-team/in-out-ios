//
//  APIService.swift
//  App
//
//  Created by kwh on 7/4/24.
//

import Foundation

enum HttpMethod: String {
    case POST
    case PUT
    case GET
    case DELETE
    // Ohter http methods
}

enum NetworkError: Error {
    case badUrl
    case badRequest(BadRequestError)
    case networkError(Error?)
    case decodingError
    case encodeingError
    case notAuthenticated
}

struct ErrorResponse: Decodable {
    let code: Int
    let message: String
}

struct BadRequestError {
    let data: Data?
    let errorResponse: ErrorResponse?
}

struct EmptyResponse: Decodable {}

protocol APIServiceDelegate: AnyObject {
    func onLoading(path: String?, isLoading: Bool)
}

final class APIService {
    private init() {}
    static let shared = APIService()
    
    let decoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    weak var delegate: APIServiceDelegate?
    
    func fetch<Response: Decodable>(_ method: HttpMethod, _ path: String? = nil, _ params: [String: String]? = nil , _ body: Encodable? = nil) async -> Result<Response, NetworkError> {
        
        // MARK: async fetch는 내부 모든 컨텍스트(토큰 만료로 인한 갱신 및 리패치 포함)가 모두 끝날때까지 기다리게 설계됨.
        // MARK: 즉, defer의 호출은 쿼리 호출이 모두 완료(혹은 중간에 중단)되었다는 것을 보장함.
        // fetch 함수 시작 loading -> true
        delegate?.onLoading(path: path, isLoading: true)
        // fetch 함수의 종료(반환)시 loading -> false
        defer {
            delegate?.onLoading(path: path, isLoading: false)
        }
        
        do {
            var url = Config.apiUrl
            
            // Step 1: endpoint path setting
            if let path = path {
                url.appendPathComponent(path)
            }
            
            // Step 2: create URLComponents
            guard var urlComponents = URLComponents(string: url.absoluteString) else { return .failure(.badUrl) }
            
            // Step 3: query paramenters setting
            if let params = params {
                urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
            }
            
            // Step 4: create URLRequest
            guard let requestUrl = urlComponents.url else { return .failure(.badUrl) }
            var request = URLRequest(url: requestUrl)
            
            // Step 5: http header setting
            request.setValue("application/json", forHTTPHeaderField: "Content-Type") // 요청타입: JSON
            request.setValue("application/json", forHTTPHeaderField: "Accept") // 응답타입: JSON
             if let token = UserService.shared.getAccessToken(), !token.isEmpty {
                 request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization") // JWT 토큰
             }
            
            // Step 6: http method setting
            request.httpMethod = method.rawValue
            
            // Step 7: body setting by method
            switch(method) {
            case .GET:
                break
            case .POST, .PUT, .DELETE:
                if let body = body {
                    if let jsonData = try? JSONEncoder().encode(body) {
                        request.httpBody = jsonData
                    } else {
                        return .failure(.encodeingError)
                    }
                }
                // Other handle http methods
            }
            
            try await Task.sleep(nanoseconds: UInt64(1.0 * 1_000_000_000))

            // Step 8: resume url session task
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if (response as? HTTPURLResponse)?.statusCode == 401 {
                // TODO: 리프레시 토큰
                return .failure(.notAuthenticated)
                // return await updateAccessToken(request: request)
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                
                if let errorResponse = try? self.decoder.decode(ErrorResponse.self, from: data) {
                    return .failure(.badRequest(BadRequestError(data: data, errorResponse: errorResponse)))
                }

                return .failure(.badRequest(BadRequestError(data: data, errorResponse: nil)))
                
            }
            
            if data.isEmpty, Response.self == EmptyResponse.self {
                return .success(EmptyResponse() as! Response)
            }
            
            guard let parsedData = try? self.decoder.decode(Response.self, from: data) else {
                return .failure(.decodingError)
            }
            
            return .success(parsedData)
        } catch {
            return .failure(.networkError(error))
        }
    }
    
    private func updateAccessToken<Response: Decodable>(request: URLRequest) async -> Result<Response, NetworkError> {
        // TODO: 리프레시 토큰 서버측 구현되면 구현 예정
        return .success(EmptyResponse() as! Response)
    }
}

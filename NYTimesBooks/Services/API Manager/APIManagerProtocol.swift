//
//  APIManagerProtocol.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 04.02.2023.
//

import Foundation
enum HttpMethod: String {
    case get, put, post, patch, delete
}

protocol APIManager {
    // swiftlint:disable function_parameter_count
    func request<T>(urlString: String,
                    method: HttpMethod,
                    dataType: T.Type,
                    headers: [String: String]?,
                    parameters: [String: Any]?,
                    completion: @escaping (_ data: T?, _ error: Error?) -> Void) where T: Decodable
}

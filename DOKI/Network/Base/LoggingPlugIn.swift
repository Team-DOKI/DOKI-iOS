//
//  LoggingPlugIn.swift
//  DOKI
//
//  Created by 권석기 on 7/15/25.
//

import Foundation

import Moya

final class MoyaLoggingPlugin: PluginType {

    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            print("✖✖✖ Moya Invalid Request ✖✖✖")
            return
        }
        
        let url = httpRequest.url?.absoluteString ?? "nil"
        let method = httpRequest.httpMethod ?? "UNKNOWN"
        
        print("""
        
        ✈✈✈ REQUEST ✈✈✈
        [\(method)] \(url)
        TARGET: \(target)
        HEADERS: \(httpRequest.allHTTPHeaderFields ?? [:])
        """)
        
        if let body = httpRequest.httpBody,
           let pretty = prettyPrintedJSON(body) {
            print("REQUEST BODY:\n\(pretty)")
        }
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            logResponse(response, target: target)
            
        case let .failure(error):
            logError(error, target: target)
        }
    }
    
    private func logResponse(_ response: Response, target: TargetType) {
        let url = response.request?.url?.absoluteString ?? "nil"
        
        print("""
        
        ✉✉✉ RESPONSE ✉✉✉
        [\(response.statusCode)] \(url)
        TARGET: \(target)
        """)
        
        if let pretty = prettyPrintedJSON(response.data) {
            print("RESPONSE BODY:\n\(pretty)")
        } else if let raw = String(data: response.data, encoding: .utf8) {
            print("RESPONSE BODY:\n\(raw)")
        }
    }
    
    private func logError(_ error: MoyaError, target: TargetType) {
        print("""
        
        ✖✖✖ ERROR ✖✖✖
        TARGET: \(target)
        CODE: \(error.errorCode)
        MESSAGE: \(error.failureReason ?? error.localizedDescription)
        """)
        
        if let response = error.response {
            logResponse(response, target: target)
        }
    }
    
    private func prettyPrintedJSON(_ data: Data) -> String? {
        guard
            let object = try? JSONSerialization.jsonObject(with: data),
            let prettyData = try? JSONSerialization.data(
                withJSONObject: object,
                options: [.prettyPrinted]
            ),
            let prettyString = String(data: prettyData, encoding: .utf8)
        else {
            return nil
        }
        
        return prettyString
    }
}

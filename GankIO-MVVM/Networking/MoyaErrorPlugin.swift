//
//  MoyaErrorPlugin.swift
//  GankIO-MVVM
//
//  Created by james.li on 2019/6/22.
//  Copyright © 2019 james.li. All rights reserved.
//

import Foundation
import Moya
import Result //bug: it must import, otherwise didReceive doesn't callback
import Moya_ObjectMapper
class MoyaErrorPlugin: PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
        logDebug("errorPlugin willSend")
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        logDebug("errorPlugin didReceive")
        switch result {
        case .success(let response):
            logDebug("errorPlugin response= \(String(data: response.data, encoding: .utf8) ?? "no data")")
            //处理服务器错误
            do {
                let filteredResponse = try response.filterSuccessfulStatusCodes()
                let json = try filteredResponse.mapJSON() // type Any
                logDebug("errorPlugin json\(json)")
                // Do something with your json.
                if let data = json as? [String: Any], data["error"] != nil, data["error"]! as? Bool ?? false {
                    logError("errorPlugin server error")
                }else {
                    logDebug("errorPlugin server success")
                }
            }
            catch let error {
                logError("errorPlugin parse json error=\(error)")
            }
        case .failure(let error):
            logError("errorPlugin moya error= \(error.response?.statusCode ?? -1)")
        }
    }
}

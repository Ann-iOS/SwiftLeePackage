//
//  File.swift
//  
//
//  Created by iOS on 2021/6/18.
//

import Foundation

public class DBRequestCollection: NSObject {

    /// 获取用户信息
    /// - Parameters:
    ///   - urlStr: Get请求 .库的地址链接 +  公开的地址字符串   例如: https://chain-ytbox.dbchain.cloud/relay/auth/accounts/cosmos1557ygk9vkplf82a34nyrgnyt9negrd2k6e9zek
    ///   - userModelCloure: 用户模型
    ///   - failure: 错误返回code和message
    public func getUserAccountNum(urlStr:String,userModelCloure:@escaping (UserModel) -> Void,failure : ((Int?, String) ->Void)?){
        DBRequest.GET(url: urlStr, params: nil) { (json) in
            let decoder = JSONDecoder()
            let insertModel = try? decoder.decode(UserModel.self, from: json)
            guard let model = insertModel else {
                return
            }
            DispatchQueue.main.async {
                userModelCloure(model)
            }
        } failure: { (code, message) in
            DispatchQueue.main.async {
                failure?(code,message)
            }
        }
    }
}

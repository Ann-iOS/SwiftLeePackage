//
//  File.swift
//  
//
//  Created by iOS on 2021/6/18.
//

import Foundation

public class RequestCollection: NSObject {
    // 获取用户信息
    func getUserAccountNum(OutAddress: String,urlStr:String,userModelCloure:@escaping (UserModel) -> Void,failure : ((Int?, String) ->Void)?){

        let url = urlStr + OutAddress

        DBRequest.GET(url: url, params: nil) { (json) in
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

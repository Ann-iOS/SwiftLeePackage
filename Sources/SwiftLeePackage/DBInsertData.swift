//
//  File.swift
//  
//
//  Created by iOS on 2021/6/19.
//

import Foundation
import UIKit
import Alamofire

public class InsertDara {

    var msgArr = [Dictionary<String, Any>]()
    // 准备签名数据
    let fee : [String:Any] = ["amount":[],"gas":"99999999"]

    /// 最终提交数据
    /// - Parameters:
    ///   - urlStr: 插入数据的url地址.
    ///   - publikeyBase: 公钥的 base64 字符串
    ///   - signature: 签名数据
    ///   - insertDataStatusBlock: 返回结果. 类型为 int ,
    ///   返回结果的参数说明 :
    ///   返回 0  表示查询结果的倒计时结束, 数据插入不成功.
    ///   返回 1  表示数据已成功插入数据库
    ///   返回 2  表示该条数据插入的结果还处于等待状态.
    public func insertRowData(urlStr:String,publikeyBase:String ,signature: Data,insertDataStatusBlock:@escaping(_ Status:String) -> Void) {

        let sign = signature.base64EncodedString()

//        let publikeyBase = PasswordManager.getOutPublikeyData()!.base64EncodedString()

        let signDivSorted = ["key":["type":"tendermint/PubKeySecp256k1",
                                    "value":publikeyBase]]

        let typeSignDiv = sortedDictionarybyLowercaseString(dic: signDivSorted)

        let signDic = ["key":["pub_key":typeSignDiv[0],
                              "signature":sign]]

        let signDiv = sortedDictionarybyLowercaseString(dic: signDic)

        let tx = ["key":["memo":"",
                         "fee":fee,
                         "msg":msgArr,
                         "signatures":[signDiv[0]]]]

        let sortTX = sortedDictionarybyLowercaseString(dic: tx)

        let dataSort = sortedDictionarybyLowercaseString(dic: ["key": ["mode":"async","tx":sortTX[0]]])

        let isTimerExistence = DBGCDTimer.shared.isExistTimer(WithTimerName: "VerificationHash")
        
        DBRequest.POST(url: urlStr, params:( dataSort[0] )) { [self] (json) in
             let decoder = JSONDecoder()
             let insertModel = try? decoder.decode(InsertModel.self, from: json)
             guard let model = insertModel else {
                 return
             }

            if !(model.txhash?.isBlank ?? true) {
                /// 开启定时器 循环查询结果
                if isTimerExistence == true{
                    DBGCDTimer.shared.cancleTimer(WithTimerName: "DBVerificationHash")
                }

                /// 查询请求最长等待时长
                var waitTime = 15

                DBGCDTimer.shared.scheduledDispatchTimer(WithTimerName: "DBVerificationHash", timeInterval: 1, queue: .main, repeats: true) {
                    waitTime -= 1
                    if waitTime > 0 {
                        verificationHash(url: urlStr, hash: model.txhash!) { (status) in
                            NSLog("verificationHash:\(status),时间和次数:\(waitTime)")
                            if status != "2"{
                                //  成功或失败都直接返回 停止计时器
                                insertDataStatusBlock(status)
                                DBGCDTimer.shared.cancleTimer(WithTimerName: "DBVerificationHash")
                            }
                        }
                    } else {
                        /// 最长循环等待时间已过. 取消定时器
                        insertDataStatusBlock("0")
                        DBGCDTimer.shared.cancleTimer(WithTimerName: "DBVerificationHash")
                    }
                }
            } else {
                insertDataStatusBlock("0")
            }

         } failure: { (code, message) in

            if isTimerExistence == true{
                DBGCDTimer.shared.cancleTimer(WithTimerName: "DBVerificationHash")
            }
            insertDataStatusBlock("0")
        }
     }

    /// 字典排序
    public func sortedDictionarybyLowercaseString(dic:Dictionary<String, Any>) -> [[String:Any]] {
        let allkeyArray  = dic.keys
        let afterSortKeyArray = allkeyArray.sorted(by: {$0 < $1})
        var valueArray = [[String:Any]]()
        afterSortKeyArray.forEach { (sortString) in
            let valuestring = dic[sortString]
            valueArray.append(valuestring as! [String:Any])
        }
        return valueArray
    }


    /// 检查数据是否已经插入成功
    /// - Parameters:
    //       let token = Token().createAccessToken()
    //       let requestUrl = BASEURL + "dbchain/tx-simple-result/" + "\(token)/" + "/\(hash)"
    ///   - url: 地址
    ///   - hash: 插入数据时返回的hash值
    /// - Returns: 不为空则是成功
    public func verificationHash(url:String,hash:String,verifiSuccessBlock:@escaping(_ status: String) -> Void){

       DBRequest.GET(url: url, params: nil) { [weak self] (data) in
         guard let mySelf = self else {return}
        let json = mySelf.dataToJSON(data: data as NSData)
        if json.keys.count > 0 {
           /// 状态:  0: 错误 已经失败  1:  成功  2: 等待
           if json["error"] != nil {
               verifiSuccessBlock("0")
           } else {
            let result = json["result"] as? [String:Any]
               let status = result?["state"]
               if status as! String == "pending" {
                   verifiSuccessBlock("2")
               } else if status as! String == "success" {
                   verifiSuccessBlock("1")
               } else {
                   verifiSuccessBlock("0")
               }
           }
        } else {
            verifiSuccessBlock("0")
        }

      } failure: { (code, message) in
           verifiSuccessBlock("0")
      }
    }

    public func dataToJSON(data:NSData) ->[String : Any] {
        var result = [String : Any]()

        if let dic = try? JSONSerialization.jsonObject(with: data as Data,
                                                       options: .mutableContainers) as? [String : Any] {
            result = dic
        }

        return result
    }
}



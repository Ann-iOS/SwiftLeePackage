//
//  File.swift
//  
//
//  Created by iOS on 2021/6/18.
//

import Foundation

class Token {

    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
          let timeInterval: TimeInterval = Date().timeIntervalSince1970
          let millisecond = CLongLong(round(timeInterval*1000))
          return "\(millisecond)"
      }

    public func createAccessToken(privateKey:[UInt8],PublikeyData:Data) -> String {
        let millisecond = self.milliStamp
        let secondUint = [UInt8](millisecond.utf8)
        do{
            let signMilliSecond = try signSawtoothSigning(data: secondUint, privateKey: privateKey)

            let timeBase58 = Base58.encode(signMilliSecond)

            let publicKeyBase58 = Base58.encode(PublikeyData)

            return "\(publicKeyBase58):" + "\(millisecond):" + "\(timeBase58)"

        } catch {
            return ""
        }
    }
}

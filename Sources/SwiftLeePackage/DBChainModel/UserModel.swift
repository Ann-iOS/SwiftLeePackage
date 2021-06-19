//
//  File.swift
//  
//
//  Created by iOS on 2021/6/18.
//

import Foundation

public struct UserModel: Codable {

    public var height: String
    public var result: resultModel

    public struct resultModel: Codable {
        var type: String
        var value: valueData
    }

    public struct valueData: Codable {
        var address: String
        var coins: [coinData]?
        var public_key: String
        var account_number: String
        var sequence: String
    }

    public struct coinData: Codable {
        var denom: String
        var amount: String
    }
}

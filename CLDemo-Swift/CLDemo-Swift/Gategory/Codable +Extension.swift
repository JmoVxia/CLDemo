//
//  Codable+Extension.swift
//  CL
//
//  Created by JmoVxia on 2020/5/13.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

extension Encodable {
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    func toJSONString() -> String? {
        if let bytes = toJSONData() {
            return String(bytes: bytes, encoding: .utf8)
        }
        return nil
    }
    
    func toJSON() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] } ?? [:]
    }
}

extension Decodable {
    static func map(JSONData: Data) -> Self? {
        do {
            return try JSONDecoder().decode(Self.self, from: JSONData)
        } catch let error {
            print(error)
            return nil
        }
    }
    static func map(JSONString: String) -> Self? {
        do {
            return try JSONDecoder().decode(Self.self, from: Data(JSONString.utf8))
        } catch let error {
            print(error)
            return nil
        }
    }
    
    static func map(JSONObject: Any) -> Self? {
        guard JSONSerialization.isValidJSONObject(JSONObject) else {
            print("JSONSerialization : Invalid object")
            return nil
        }
        if let data = try? JSONSerialization.data(withJSONObject: JSONObject, options: .prettyPrinted) {
            do {
                return try JSONDecoder().decode(Self.self, from: data)
            } catch let error {
                print(error.localizedDescription)
                return nil
            }
        }
        return nil
    }
}

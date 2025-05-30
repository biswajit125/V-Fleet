//
//  Dictionary.swift
//  Soulmate
//
//  Created by Chitra on 29/12/22.
//

import Foundation

extension Dictionary {
    
    func jsonData() -> Data {
        do {
            let data = try JSONSerialization.data(withJSONObject: self)
            return data
        } catch let error {
            print("can not serialize dictionary: \(error.localizedDescription)")
        }
        return Data()
    }
    
    func decodeDictionary<A: Codable>() -> A? {
        let data = self.jsonData()
        let decodedData: A? = data.decode()
        return decodedData
    }
}

extension Encodable {
    
    var dictionary: [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            let obj = try JSONSerialization.jsonObject(with: data)
            return obj as? [String: Any] ?? [:]
        } catch {
            return [:]
        }
    }
    
}

extension Decodable {
    
    func decode<A: Codable>() -> A? {
        do {
            let decodedData = try JSONDecoder().decode(A.self, from: self as! Data)
            return decodedData
        } catch let error {
            print("can not decode data: \(error.localizedDescription)")
        }
        return nil
    }
    
}


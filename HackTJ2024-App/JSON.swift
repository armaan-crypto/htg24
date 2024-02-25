//
//  JSON.swift
//  HackTJ2024
//
//  Created by Armaan Ahmed on 2/25/24.
//

import Foundation

protocol JSONDelegate: AnyObject {
    func didFailWith(error: Error)
}

class JSON {
    
    weak var delegate: JSONDelegate?
    
    func value<T: Codable>(_ modelType: T.Type, _ fileName: String) -> T? {
            let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
        if !FileManager().fileExists(atPath: url.path) {
                return nil
            }
            let decoder = JSONDecoder()
            guard let data = try? Data(contentsOf: url) else {
                return nil
            }
            guard let items = try? decoder.decode(modelType, from: data) else {
                return nil
            }
            return items
        }
    func save<T: Encodable>(_ value: T, fileName: String) throws {
        let newUrl = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
            let encoder = JSONEncoder()
            guard let jsonData = try? encoder.encode(value) else {
                return
            }
            let itemJSON = String(data: jsonData, encoding: .utf8)
            try itemJSON?.write(to: newUrl, atomically: true, encoding: .utf8)
        }
    func delete(file: String) throws {
        let newUrl = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(file)
        try FileManager.default.removeItem(at: newUrl)
    }
}

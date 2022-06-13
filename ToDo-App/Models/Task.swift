//
//  task.swift
//  ToDo-App
//
//  Created by Amin  Bagheri  on 2022-06-11.
//
import Foundation
import MobileCoreServices

enum TaskError: Error {
    case invalidDataType, decodeFailure, encodeFailure
}


final class Task: NSObject, Codable, NSItemProviderWriting, NSItemProviderReading  {
    
    var desc: String?
    var title: String?
    var deadline: Date?
    var isCompleted: Bool?
    
    public static var writableTypeIdentifiersForItemProvider: [String] {
      return [(kUTTypeUTF8PlainText) as String]
    }

    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        do {
            // here the object is encoded to a JSON object and sent to the completion handler
            let data = try JSONEncoder().encode(self)
            progress.completedUnitCount = 100
            completionHandler(data, nil)
            
        } catch {
            completionHandler(nil, TaskError.encodeFailure)
        }
        return progress
    }
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [(kUTTypeUTF8PlainText) as String]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Task {
        let decoder = JSONDecoder()
        do {
            // here we decode the object back to it's class representative and decode it
            let task = try decoder.decode(Task.self, from: data)
            return task
        } catch {
            throw TaskError.decodeFailure
        }
    
    }
    
    
}

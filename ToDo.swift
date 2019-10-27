//
//  ToDo.swift
//  List
//
//  Created by Oleksii Kolakovskyi on 10/18/19.
//  Copyright © 2019 Aleksey. All rights reserved.
//


import Foundation

class ToDo: NSObject, NSCoding {
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    
    init(title: String, isComplete: Bool, dueDate: Date, notes: String?){
        guard !title.isEmpty else {
            fatalError("You can't save a reminder with empty title")
        }
        
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
    }
    
    
    
    static func loadSampleToDos() -> [ToDo] {
        let todo1 = ToDo(title: "Make the bed", isComplete: false, dueDate: Date(), notes: "Some notes")
        let todo2 = ToDo(title: "Empty trash", isComplete: false, dueDate: Date(), notes: "Again, notes")
        let todo3 = ToDo(title: "Go grocery shopping", isComplete: false, dueDate: Date(), notes: "Coupons!")
        
        return [todo1, todo2, todo3]
    }

    
    struct PropertyKeys {
        static let title = "title"
        static let isComplete = "isComplete"
        static let dueDate = "dueDate"
        static let notes = "notes"
    }
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("todos")
    
    static func loadToDos() -> [ToDo]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ToDo.ArchiveURL.path) as? [ToDo]
    }
    
    static func saveToDos(_ todos: [ToDo]) {
        NSKeyedArchiver.archiveRootObject(todos, toFile: ToDo.ArchiveURL.path)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let title = aDecoder.decodeObject(forKey: PropertyKeys.title) as? String,
            let dueDate = aDecoder.decodeObject(forKey: PropertyKeys.dueDate) as? Date else { return nil }
    
        let isComplete = aDecoder.decodeBool(forKey: PropertyKeys.isComplete)
        let notes = aDecoder.decodeObject(forKey: PropertyKeys.notes) as? String
        
        self.init(title:title, isComplete: isComplete, dueDate: dueDate, notes: notes)
    }
    // This stuff will be done each time todo.encode is called
    func encode(with aCoder:NSCoder) {
        aCoder.encode(title, forKey: PropertyKeys.title)
        aCoder.encode(isComplete, forKey: PropertyKeys.isComplete)
        aCoder.encode(dueDate, forKey: PropertyKeys.dueDate)
        aCoder.encode(notes, forKey: PropertyKeys.notes)
        
    }
}

//
//  TaskDataSource.swift
//  TaskApp-DesignPattern-MVC
//
//  Created by yodaaa on 2019/04/08.
//  Copyright © 2019 yodaaa. All rights reserved.
//

import Foundation

class TaskDataSource: NSObject {
    private var tasks = [Task]()
    
    func loadData() {
        let userDefaults = UserDefaults.standard
        let taskDictionaries = userDefaults.object(forKey: "tasks") as? [[String: Any]]
        guard let t = taskDictionaries else { return }
        
        //tasks.removeAll()
        for dic in t {
            let task = Task(from: dic)
            Logger.debugLog(dic)
            tasks.append(task)

        }
    }
    
    func save(task: Task) {
        tasks.append(task)
        
        var taskDictionaries = [[String: Any]]()
        for t in tasks {
            let taskDictionary: [String: Any] = ["text": t.text, "deadline": t.deadline]
            taskDictionaries.append(taskDictionary)
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(taskDictionaries, forKey: "tasks")
        userDefaults.synchronize()
    }
    
    func count() -> Int {
        return tasks.count
    }
    
    func date(at index: Int) -> Task? {
        if tasks.count > index {
            return tasks[index]
        }
        return nil
    }
}




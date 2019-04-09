//
//  Task.swift
//  TaskApp-DesignPattern-MVC
//
//  Created by yodaaa on 2019/04/08.
//  Copyright © 2019 yodaaa. All rights reserved.
//

import Foundation

class Task {
    let text: String
    let deadline: Date
    
    init(text: String, deadline: Date) {
        self.text = text
        self.deadline = deadline
    }
    
    init(from dictionary: [String: Any]) {
        self.text = dictionary["text"] as! String
        self.deadline = dictionary["deadline"] as! Date
    }
    
}

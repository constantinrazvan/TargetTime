//
//  Todo.swift
//  TodoList
//
//  Created by Constantin Razvan on 2021-11-03.
//

import Foundation

struct Todo {
  let title: String
  let isComplete: Bool
  
  init(title: String, isComplete: Bool = false) {
    self.title = title
    self.isComplete = isComplete
  }
  
  func completeToggled() -> Todo {
    return Todo(title: title, isComplete: !isComplete)
  }
}

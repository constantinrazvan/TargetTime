//
//  ViewController.swift
//  TodoList
//
//  Created by Constantin Razvan on 2021-11-03.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
  
    //MARK: - Variables, Constants
    var todo: Todo?

    @IBOutlet weak var button: UIButton!
    
    var todos = [
        Todo(title: "Swipe left to remove"),
        Todo(title: "Swipe right to complete "),
        Todo(title: "Tap on box to complete"),
        Todo(title: "Tap on text to edit"),
        Todo(title: "Tap on plus button to add item")
      ]
    
    //MARK: - IBOutles
    @IBOutlet weak var tableView: UITableView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
      
      let center = UNUserNotificationCenter.current()
      
      center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in }
      
      let content = UNMutableNotificationContent()
      content.title = "TargetTime"
      content.body = "Did you took your targets today?"
      
      let date = Date().addingTimeInterval(5)
      let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
      
      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
      
      let uuidString = UUID().uuidString
      let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
      
      center.add(request) { (error) in }
      
  }
    
    @IBSegueAction func todoViewcontroller(_ coder: NSCoder) -> TodoViewController? {
        let vc = TodoViewController(coder: coder)
        
        if let indexpath = tableView.indexPathForSelectedRow {
          let todo = todos[indexpath.row]
          vc?.todo = todo
        }
          
          vc?.delegate = self
          vc?.presentationController?.delegate = self
          vc?.modalPresentationStyle = .overFullScreen
        
          return vc
        }
    }

extension ViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .normal, title: "Complete") { action, view, complete in
      
      let todo = self.todos[indexPath.row].completeToggled()
      self.todos[indexPath.row] = todo
      
      let cell = tableView.cellForRow(at: indexPath) as! CheckTableViewCell
      cell.set(checked: todo.isComplete)
      complete(true)
        
      print("complete")
    }
      action.backgroundColor = .systemIndigo
    
    return UISwipeActionsConfiguration(actions: [action])
  }
  
      func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! CheckTableViewCell
    cell.delegate = self
    
    let todo = todos[indexPath.row]
    cell.set(title: todo.title, checked: todo.isComplete)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      todos.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let todo = todos.remove(at: sourceIndexPath.row)
    todos.insert(todo, at: destinationIndexPath.row)
    }
}

extension ViewController: CheckTableViewCellDelegate {
  func checkTableViewCell(_ cell: CheckTableViewCell, didChagneCheckedState checked: Bool) {
    guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
    let todo = todos[indexPath.row]
    let newTodo = Todo(title: todo.title, isComplete: checked)
    
    todos[indexPath.row] = newTodo
    }
}

extension ViewController: TodoViewControllerDelegate {
  func todoViewController(_ vc: TodoViewController, didSaveTodo todo: Todo) {
    dismiss(animated: true) {
      if let indexPath = self.tableView.indexPathForSelectedRow {
        // update
        self.todos[indexPath.row] = todo
        self.tableView.reloadRows(at: [indexPath], with: .none)
      } else {
        // create
        self.todos.append(todo)
        self.tableView.insertRows(at: [IndexPath(row: self.todos.count-1, section: 0)], with: .automatic)
            }
        }
    }
}

extension ViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    if let indexPath = tableView.indexPathForSelectedRow {
        tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

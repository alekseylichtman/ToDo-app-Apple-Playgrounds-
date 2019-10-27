import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
    
    
    
    // Action
    
    // Variable
    var todos = [ToDo]()
    
    // Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Easy Edit-Delete functionality view left bar button
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedToDos = ToDo.loadToDos() {
            todos = savedToDos
        } else {
            todos = ToDo.loadSampleToDos()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var validToDos = [ToDo]()
        for todo in todos {
            if todo.title.isEmpty == false && todo.title.hasPrefix(" ") == false {
                validToDos.append(todo)
            }
        }
        todos = validToDos
        
        todos.sort { (first, second) -> Bool in
            return first.dueDate < second.dueDate
        }
        
        tableView.reloadData()
    }
    
    func getComoletedToDos() -> [ToDo] {
        var completedToDos = [ToDo]()
        for todo in todos {
            if todo.isComplete == true {
                completedToDos.append(todo)
            }
        }
        return completedToDos
    }
    
    func getUnCompletedToDos() -> [ToDo] {
        var uncompletedToDos = [ToDo]()
        for todo in todos {
            if todo.isComplete == false {
                uncompletedToDos.append(todo)
            }
        }
        return uncompletedToDos
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var unComplete = 0
        for todo in todos {
            if todo.isComplete == false {
                unComplete += 1
            }
        }
        
        if section == 0 {
            return unComplete
        } else {
            return todos.count - unComplete
        }
    }
    
    
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Set cell or fail
        var todo: ToDo? = nil
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentefier") as? ToDoCell
            else { fatalError("Could not dequeue a cell.") }
        // Make cell
        if indexPath.section == 0 {
            todo = getUnCompletedToDos()[indexPath.row]
        } else if indexPath.section == 1 {
            todo = getComoletedToDos()[indexPath.row]
            
        }
        //....
        
        cell.titleLabel?.text = todo!.title
        cell.isCompleteButton.isSelected = todo!.isComplete
        cell.delegate = self
        cell.toDoDueDate.text = ToDo.dueDateFormatter.string(from: todo!.dueDate)
        // Return cell
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var l = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
//        l.text = ";;;;;;kkjjkkj"
//        
//        return l
//    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(todos)
        }
    }
    
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            
            if indexPath.section == 0 {
                let todo = getUnCompletedToDos()[indexPath.row]
                todo.isComplete = !todo.isComplete
                ToDo.saveToDos(todos)
                tableView.reloadData()
            } else if indexPath.section == 1 {
                let todo = getComoletedToDos()[indexPath.row]
                todo.isComplete = !todo.isComplete
                ToDo.saveToDos(todos)
                tableView.reloadData()
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let todoViewController = segue.destination as! ToDoViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedToDo = todos[indexPath.row]
            todoViewController.todo = selectedToDo
            
        } else if segue.identifier == "newToDo" {
            let newTodo = ToDo(title: "To Do", isComplete: false, dueDate: Date(), notes: nil)
            newTodo.title = ""
            let todoViewController = segue.destination as! ToDoViewController
            todoViewController.todo = newTodo
            todos.append(newTodo)
        }
    }
    
    
}

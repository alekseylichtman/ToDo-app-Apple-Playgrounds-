import UIKit

class ToDoViewController: UITableViewController {
 
    var todos = [ToDo]()
    var isEndDatePickerHidden = false
    var todo: ToDo?
    
    // Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    // Action
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBAction func returnPressed(_ sender: UITextField) {
        titleTextField.resignFirstResponder()
    }
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        isCompleteButton.isSelected = !isCompleteButton.isSelected
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: dueDatePickerView.date)
    }
    
    @IBAction func saveTapped() {
        todo?.title = titleTextField.text!
        todo?.isComplete = isCompleteButton.isSelected
        todo?.dueDate = dueDatePickerView.date
        todo?.notes = notesTextView.text
        navigationController?.popViewController(animated: true)
        
        
        
        
//
//        let sourceViewController = segue.source as! ToDoViewController
//
//        if let todo = sourceViewController.todo {
//            if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                todos[selectedIndexPath.row ] = todo
//                tableView.reloadRows(at: [selectedIndexPath], with: .none)
//            } else {
//                let newIndexPath = IndexPath(row: todos.count, section: 0)
//
//                    todos.append(todo)
//                tableView.insertRows(at: [newIndexPath], with: .automatic)
//            }
//        }
//
//        ToDo.saveToDos(todos)
    }
    
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        performSegue(withIdentifier: "unwindSegue", sender: nil)
        return
        guard segue.identifier == "saveUnwind" else { return }
        
    }
    
    
    
    // Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        if let todo = todo {
            navigationItem.title = "To Do"
            titleTextField.text = todo.title
            isCompleteButton.isSelected = todo.isComplete
            dueDatePickerView.date = todo.dueDate
            notesTextView.text = todo.notes
        } else {
            dueDatePickerView.date = Date().addingTimeInterval(24*60*60)
        }
        updateSaveButtonState()
        updateDueDateLabel(date: dueDatePickerView.date)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch(indexPath) {
        case[1,0]:
            isEndDatePickerHidden = !isEndDatePickerHidden
        
            dueDateLabel.textColor = isEndDatePickerHidden ? .black : tableView.tintColor
        
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = ToDo.dueDateFormatter.string(from: date)
    }
    
    func updateSaveButtonState() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        segue.destination
        
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
        
        todo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
        
    }
    

}

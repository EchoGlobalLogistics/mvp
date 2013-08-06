using System.Collections.Generic;

using Todo.Presenter.Models;

namespace Todo.Presenter.Behaviors
{
    public interface ITodoListManager
    {
        IEnumerable<TodoItem> Add(string description);

        IEnumerable<TodoItem> Remove(TodoItem todoItem);
            
        IEnumerable<TodoItem> GetList();

        IEnumerable<TodoItem> GetActiveList();
        
        IEnumerable<TodoItem> GetCompletedList();

        IEnumerable<TodoItem> ClearCompleted();
    }
}

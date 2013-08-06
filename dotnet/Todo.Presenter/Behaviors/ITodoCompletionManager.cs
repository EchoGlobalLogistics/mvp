using System.Collections.Generic;

using Todo.Presenter.Models;

namespace Todo.Presenter.Behaviors
{
    public interface ITodoCompletionManager
    {
        TodoItem ToggleComplete(TodoItem todoItem);

        IEnumerable<TodoItem> ToggleAllComplete();
    }
}

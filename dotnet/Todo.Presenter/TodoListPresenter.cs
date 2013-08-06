using System.Collections.Generic;
using System.Linq;

using Todo.Data;
using Todo.Presenter.Behaviors;
using Todo.Presenter.Commands;
using Todo.Presenter.Models;

namespace Todo.Presenter
{
    public class TodoListPresenter : ITodoListManager,
                                     ITodoCompletionManager
    {
        public ITodoPersistor<TodoItem> Persistor { private get; set; }

        public TodoListPresenter()
        {
            this.ViewModel = new TodoListViewModel();
            Persistor = TodoDataAdapter.Instance;
        }

        public TodoListViewModel ViewModel { get; set; }

        public IEnumerable<TodoItem> Add(string description)
        {
            var command = new AddTodo
                {
                    Input = new AddTodoInput(description, this.ViewModel.TodoItems),
                    Persistor = this.Persistor
                };
            command.Execute();

            ViewModel.TodoItems = command.Value.ToList();

            return command.Value;
        }

        public IEnumerable<TodoItem> Remove(TodoItem todoItem)
        {
            var command = new RemoveTodo { Input = todoItem, Persistor = this.Persistor };
            command.Execute();

            ViewModel.TodoItems = command.Value.ToList();

            return command.Value;
        }

        public IEnumerable<TodoItem> GetList()
        {
            var command = new FetchTodoList { Persistor = this.Persistor };
            command.Execute();

            ViewModel.TodoItems = command.Value.ToList();

            return command.Value;
        }

        public IEnumerable<TodoItem> GetActiveList()
        {
            this.GetList();
            var command = new FilterTodosByCompletion
                {
                    Input = new FilterTodosByCompletionInput(this.ViewModel.TodoItems, FilterTodosByCompletionType.HideCompleted)
                };
            command.Execute();

            ViewModel.TodoItems = command.Value.ToList();

            ViewModel.CurrentState = TodoListState.Active;

            return command.Value;
        }

        public IEnumerable<TodoItem> GetCompletedList()
        {
            this.GetList();
            var command = new FilterTodosByCompletion
                {
                    Input = new FilterTodosByCompletionInput(this.ViewModel.TodoItems, FilterTodosByCompletionType.ShowCompleted)
                };
            command.Execute();

            ViewModel.TodoItems = command.Value.ToList();

            ViewModel.CurrentState = TodoListState.Completed;

            return command.Value;
        }

        public IEnumerable<TodoItem> ClearCompleted()
        {
            this.GetList();
            var command = new RemoveCompletedTodos { Input = this.ViewModel.TodoItems, Persistor = this.Persistor };

            command.Execute();

            ViewModel.TodoItems = command.Value.ToList();

            return command.Value;
        }

        public TodoItem ToggleComplete(TodoItem todoItem)
        {
            var command = new ToggelCompleteTodo { Input = todoItem, Persistor = this.Persistor };
            command.Execute();

            ViewModel.TodoItems[todoItem.Id] = command.Value;

            return command.Value;
        }

        public IEnumerable<TodoItem> ToggleAllComplete()
        {
            this.GetList();
            var command = new ToggleAllTodos
                {
                    Input = new ToggleAllTodosInput { Items = ViewModel.TodoItems, Completed = !ViewModel.AllItemsComplete },
                    Persistor = this.Persistor
                };
            command.Execute();

            ViewModel.TodoItems = command.Value.ToList();

            return command.Value;
        }
    }
}

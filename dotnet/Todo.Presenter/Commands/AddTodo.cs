using System;
using System.Collections.Generic;

using Echo.Core.Command;

using Todo.Data;
using Todo.Presenter.Models;

namespace Todo.Presenter.Commands
{
    class AddTodoInput
    {
        public AddTodoInput(string todoDescription, IEnumerable<TodoItem> todoItems)
        {
            this.TodoDescription = todoDescription;
            this.TodoItems = todoItems;
        }

        public string TodoDescription { get; private set;  }

        public IEnumerable<TodoItem> TodoItems { get; private set; }
    }

    class AddTodo : ICommand<CommandStatus, AddTodoInput, IEnumerable<TodoItem>>
    {
        public AddTodoInput Input { set; private get; }

        public IEnumerable<TodoItem> Value { get; private set; }

        public CommandStatus Status { get; set; }

        public ITodoPersistor<TodoItem> Persistor { get; set; }

        public void Execute()
        {
            Status = CommandStatus.Executing;

            if (Input == null)
            {
                Status = CommandStatus.Failure;

                throw new NullReferenceException("Input must not be null");
            }

            Value = Persistor.Add(new TodoItem(Persistor.NextId, Input.TodoDescription));

            Status = CommandStatus.Success;
        }
    }
}

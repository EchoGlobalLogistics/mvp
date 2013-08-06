using System.Collections.Generic;
using System.Linq;

using Echo.Core.Command;

using Todo.Data;
using Todo.Presenter.Models;

namespace Todo.Presenter.Commands
{
    class ToggleAllTodosInput
    {
        public IEnumerable<TodoItem> Items { get; set; }
        public bool Completed { get; set; }
    }

    class ToggleAllTodos : ICommand<CommandStatus, ToggleAllTodosInput, IEnumerable<TodoItem>>
    {
        public IEnumerable<TodoItem> Value { get; private set; }

        public ToggleAllTodosInput Input { set; private get; }

        public CommandStatus Status { get; private set; }

        public ITodoPersistor<TodoItem> Persistor { get; set; }

        public void Execute()
        {
            Status = CommandStatus.Executing;

            Value = Input.Items.Select(i =>
                {
                    i.Completed = Input.Completed;
                    return i;
                });

            Persistor.SaveAll(Value);

            Status = CommandStatus.Success;
        }

    }
}

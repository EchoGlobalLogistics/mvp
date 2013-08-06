using System.Collections.Generic;

using Echo.Core.Command;

using Todo.Data;
using Todo.Presenter.Models;

namespace Todo.Presenter.Commands
{
    class RemoveTodo : ICommand<CommandStatus, TodoItem, IEnumerable<TodoItem>>
    {
        public TodoItem Input { set; private get; }

        public IEnumerable<TodoItem> Value { get; private set; }

        public CommandStatus Status { get; private set; }

        public ITodoPersistor<TodoItem> Persistor { get; set; }

        public void Execute()
        {
            Status = CommandStatus.Executing;

            Value = Persistor.Remove(Input.Id, Input);

            Status = CommandStatus.Success;
        }
    }
}

using System.Collections.Generic;
using System.Linq;

using Echo.Core.Command;

using Todo.Data;
using Todo.Presenter.Models;

namespace Todo.Presenter.Commands
{
    class RemoveCompletedTodos : ICommand<CommandStatus, IEnumerable<TodoItem>, IEnumerable<TodoItem>>
    {
        public IEnumerable<TodoItem> Value { get; private set; }

        public IEnumerable<TodoItem> Input { set; private get; }

        public CommandStatus Status { get; set; }

        public ITodoPersistor<TodoItem> Persistor { get; set; }

        public void Execute()
        {
            Status = CommandStatus.Executing;

            Value = Input.Where(i => !i.Completed);

            Persistor.SaveAll(Value);

            Status = CommandStatus.Success;
        }
    }
}

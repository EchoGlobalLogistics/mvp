using System.Collections.Generic;

using Echo.Core;
using Echo.Core.Command;

using Todo.Data;
using Todo.Presenter.Models;

namespace Todo.Presenter.Commands
{
    class FetchTodoList : ICommand<CommandStatus>, IHasValue<IEnumerable<TodoItem>>
    {
        public CommandStatus Status { get; private set; }

        public ITodoPersistor<TodoItem> Persistor { get; set; }

        public void Execute()
        {
            Status = CommandStatus.Executing;

            Value = Persistor.Fetch();

            Status = CommandStatus.Success;
        }

        public IEnumerable<TodoItem> Value { get; private set; }
    }
}

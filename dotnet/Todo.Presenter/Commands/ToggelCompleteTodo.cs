using Echo.Core.Command;

using Todo.Data;
using Todo.Presenter.Models;

namespace Todo.Presenter.Commands
{
    class ToggelCompleteTodo : ICommand<CommandStatus, TodoItem, TodoItem>
    {
        public TodoItem Value { get; private set; }

        public TodoItem Input { set; private get; }

        public CommandStatus Status { get; private set; }

        public ITodoPersistor<TodoItem> Persistor { get; set; }

        public void Execute()
        {
            Status = CommandStatus.Executing;

            Input.Completed = !Input.Completed;

            Value = Persistor.Edit(Input.Id, Input);

            Status = CommandStatus.Success;
        }
    }
}

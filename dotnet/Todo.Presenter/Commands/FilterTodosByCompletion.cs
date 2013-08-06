using System;
using System.Collections.Generic;
using System.Linq;

using Echo.Core.Command;

using Todo.Presenter.Models;

namespace Todo.Presenter.Commands
{
    enum FilterTodosByCompletionType
    {
        ShowCompleted,
        HideCompleted
    }

    class FilterTodosByCompletionInput
    {
        public FilterTodosByCompletionInput(IEnumerable<TodoItem> items, FilterTodosByCompletionType filterType)
        {
            this.Items = items;
            this.FilterType = filterType;
        }

        public IEnumerable<TodoItem> Items { get; private set; }

        public FilterTodosByCompletionType FilterType { get; private set; }
    }

    class FilterTodosByCompletion : ICommand<CommandStatus, FilterTodosByCompletionInput, IEnumerable<TodoItem>> 
    {
        public FilterTodosByCompletionInput Input { set; private get; }

        public IEnumerable<TodoItem> Value { get; private set; }

        public CommandStatus Status { get; private set; }

        public void Execute()
        {
            Status = CommandStatus.Executing;

            if (Input == null)
            {
                Status = CommandStatus.Failure;

                throw new NullReferenceException("Input must be set.");
            }

            switch (this.Input.FilterType)
            {
                case FilterTodosByCompletionType.ShowCompleted:
                    this.Value = this.Input.Items.Where(i => i.Completed);
                    break;
                case FilterTodosByCompletionType.HideCompleted:
                    this.Value = this.Input.Items.Where(i => !i.Completed);
                    break;
            }

            Status = CommandStatus.Success;
        }
    }
}

using System.Collections.Generic;
using System.Linq;
using System.ComponentModel;

using Todo.Presenter.Models;

namespace Todo.Presenter
{
    public class TodoListViewModel
    {
        public TodoListViewModel()
        {
            TodoItems = new List<TodoItem>();
            CurrentState = TodoListState.All;
        }

        public IList<TodoItem> TodoItems { get; set; }

        public TodoListState CurrentState { get; set; }

        public bool HasCompletedItems
        {
            get
            {
                return TodoItems.Any(i => i.Completed);
            }
        }

        [DisplayName("Mark all as complete")]
        public bool AllItemsComplete
        {
            get
            {
                return TodoItems.Any() && TodoItems.All(i => i.Completed);
            }
        }

        public int CompletedCount
        {
            get
            {
                return TodoItems.Count(i => i.Completed);
            }
        }

        public string ItemsLabel
        {
            get
            {
                return ItemsCount > 1 ? "items" : "item";
            }
        }

        public int ItemsCount
        {
            get
            {
                return TodoItems.Count();
            }
        }
    }
}

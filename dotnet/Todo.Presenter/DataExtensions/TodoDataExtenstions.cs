using System;
using System.Collections.Generic;
using System.Linq;

using Todo.Presenter.Models;

namespace Todo.Presenter.DataExtensions
{
    static class TodoDataExtenstions
    {
        public static Tuple<string, bool> ToData(this TodoItem todoItem)
        {
            return new Tuple<string, bool>(todoItem.Description, todoItem.Completed);
        }

        public static IEnumerable<Tuple<string, bool>> ToData(this IEnumerable<TodoItem> todoItems)
        {
            return todoItems.Select(i => i.ToData());
        }

        public static TodoItem FromData(this Tuple<string, bool> todoValues, int idx)
        {
            return new TodoItem(idx, todoValues.Item1)
                {
                    Completed = todoValues.Item2
                };
        }

        public static IEnumerable<TodoItem> FromData(this IEnumerable<Tuple<string, bool>> todoValues)
        {
            return todoValues.Select((todo,idx) => todo.FromData(idx));
        }
    }
}

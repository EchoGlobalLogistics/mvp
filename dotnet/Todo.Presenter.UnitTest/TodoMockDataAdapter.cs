using System.Collections.Generic;

using Todo.Data;
using Todo.Presenter.Models;
using Todo.Presenter.DataExtensions;

namespace Todo.Presenter.UnitTest
{
    class TodoMockDataAdapter : ITodoPersistor<TodoItem>
    {
        private readonly TodoPersistor _persistor;

        public TodoMockDataAdapter()
        {
            _persistor = new TodoPersistor();
        }
        
        public IEnumerable<TodoItem> Add(TodoItem todo)
        {
            return _persistor.Add(todo.ToData()).FromData();
        }

        public IEnumerable<TodoItem> Remove(int idx, TodoItem todo)
        {
            return _persistor.Remove(idx, todo.ToData()).FromData();
        }

        public TodoItem Edit(int idx, TodoItem todo)
        {
            return _persistor.Edit(idx, todo.ToData()).FromData(idx);
        }

        public IEnumerable<TodoItem> Fetch()
        {
            return _persistor.Fetch().FromData();
        }

        public int NextId
        {
            get
            {
                return _persistor.NextId;
            }
        }

        public IEnumerable<TodoItem> SaveAll(IEnumerable<TodoItem> list)
        {
            return _persistor.SaveAll(list.ToData()).FromData();
        }
    }

}

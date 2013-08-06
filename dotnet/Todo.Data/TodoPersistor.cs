using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;

namespace Todo.Data
{
    public class TodoPersistor : ITodoPersistor<Tuple<string, bool>>
    {

        private ConcurrentDictionary<int, Tuple<string, bool>> _storage;

        public TodoPersistor()
        {
            _storage = new ConcurrentDictionary<int, Tuple<string, bool>>();
        }

        public IEnumerable<Tuple<string, bool>> Add(Tuple<string, bool> todo)
        {
            _storage.TryAdd(_storage.Count(), todo);

            return _storage.Values;
        }

        public IEnumerable<Tuple<string, bool>> Remove(int idx, Tuple<string, bool> todo)
        {
            _storage.TryRemove(idx, out todo);

            var _tmp = new ConcurrentDictionary<int, Tuple<string, bool>>();
            var i = 0;
            foreach (var tuple in _storage.Values)
            {
                _tmp.TryAdd(i++, tuple);
            }

            _storage = _tmp;

            return _storage.Values;
        }

        public Tuple<string, bool> Edit(int idx, Tuple<string, bool> todo)
        {
            Tuple<string, bool> existing;
            _storage.TryGetValue(idx, out existing);
            _storage.TryUpdate(idx, todo, existing);

            return todo;
        }

        public IEnumerable<Tuple<string, bool>> SaveAll(IEnumerable<Tuple<string, bool>> list)
        {
            _storage = new ConcurrentDictionary<int, Tuple<string, bool>>();

            var enumerable = list as Tuple<string, bool>[] ?? list.ToArray();
            for (int i = 0; i < enumerable.Count(); i++)
            {
                _storage.TryAdd(i, enumerable.ElementAt(i));
            }

            return _storage.Values;
        }

        public IEnumerable<Tuple<string, bool>> Fetch()
        {
            return _storage.Values;
        }

        public int NextId
        {
            get
            {
                return _storage.Count();
            }
        }
    }
}

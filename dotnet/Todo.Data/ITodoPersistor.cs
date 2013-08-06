using System;
using System.Collections.Generic;

namespace Todo.Data
{
    public interface ITodoPersistor<TType>
    {
        IEnumerable<TType> Add(TType todo);
        IEnumerable<TType> Remove(int idx, TType todo);
        TType Edit(int idx, TType todo);
        IEnumerable<TType> Fetch();
        int NextId { get; }
        IEnumerable<TType> SaveAll(IEnumerable<TType> list);
    }
}

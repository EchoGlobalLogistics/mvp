using System;

namespace Echo.Core.Command
{
    public interface ICommand<out TExecuteStatus> 
        where TExecuteStatus : struct, IComparable
    {
        TExecuteStatus Status { get; }

        void Execute();
    }

    public interface ICommand<out TExecuteStatus, in TInput> : IHasInput<TInput>
        where TExecuteStatus : struct, IComparable
    {
        TExecuteStatus Status { get; }

        void Execute();
    }

    public interface ICommand<out TExecuteStatus, in TInput, out TValue> : IHasInput<TInput>, IHasValue<TValue>
        where TExecuteStatus : struct, IComparable
    {
        TExecuteStatus Status { get; }

        void Execute();
    }
}

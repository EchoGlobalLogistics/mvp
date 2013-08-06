namespace Echo.Core
{
    public interface IHasValue<out TValue>
    {
        TValue Value { get; }
    }
}

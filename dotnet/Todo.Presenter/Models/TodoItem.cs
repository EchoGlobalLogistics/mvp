using Echo.Core;

namespace Todo.Presenter.Models
{
    public class TodoItem : IHasId
    {
        public TodoItem(int idx, string description)
        {
            this.Description = description;
            this.Id = idx;
        }

        public TodoItem()
        {
        }

        public string Description { get; set; }
        public bool Completed { get; set; }

        public int Id { get; set; }
    }
}

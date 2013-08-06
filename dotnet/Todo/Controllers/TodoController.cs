using System.Web.Mvc;

using Todo.Presenter;
using Todo.Presenter.Models;

namespace Todo.Controllers
{
    public class TodoController : Controller
    {
        //
        // GET: /Todo/
        private readonly TodoListPresenter _todoListPresenter = new TodoListPresenter();

        public ActionResult Index()
        {
            _todoListPresenter.GetList();

            return View(_todoListPresenter.ViewModel);
        }

        [HttpPost]
        public ActionResult Add(string description)
        {
            _todoListPresenter.Add(description);

            return RedirectToAction("Index");
        }

        [HttpPost]
        public ActionResult Remove(TodoItem todoItem)
        {
            _todoListPresenter.Remove(todoItem);

            return RedirectToAction("Index");
        }

        [HttpPost]
        public ActionResult ToggelComplete(TodoItem todoItem)
        {
            _todoListPresenter.ToggleComplete(todoItem);

            return RedirectToAction("Index");
        }

        [HttpPost]
        public ActionResult ToggelAllComplete()
        {
            _todoListPresenter.ToggleAllComplete();

            return RedirectToAction("Index");
        }

        public ActionResult Active()
        {
            _todoListPresenter.GetActiveList();

            return View("Index", _todoListPresenter.ViewModel);
        }

        public ActionResult Completed()
        {
            _todoListPresenter.GetCompletedList();

            return View("Index", _todoListPresenter.ViewModel);
        }

        public ActionResult All()
        {
            return RedirectToAction("Index");
        }

        public ActionResult ClearCompleted()
        {
            _todoListPresenter.ClearCompleted();

            return RedirectToAction("Index");
        }
    }
}

using System.Linq;

using NUnit.Framework;

using Ploeh.AutoFixture;

using Todo.Presenter.Models;

namespace Todo.Presenter.UnitTest
{
    [Category("Presenter")]
    [TestFixture]
    public class TodoListPresenterTests
    {
        private Fixture _fixture;

        private TodoListPresenter _presenter;

        [TestFixtureSetUp]
        public void FixtureSetup()
        {
            _fixture = new Fixture();
        }

        [SetUp]
        public void Setup()
        {
            _presenter = new TodoListPresenter { Persistor = new TodoMockDataAdapter() };
        }

        [TestCase]
        public void TestAddTest()
        {
            _presenter.Add(_fixture.Create<string>());

            Assert.That(_presenter.ViewModel.ItemsCount == 1);
        }

        [TestCase]
        public void TestAddDuplicate()
        {
            var description = _fixture.Create<string>();
            _presenter.Add(description);
            _presenter.Add(description);

            Assert.That(_presenter.ViewModel.ItemsCount == 2);
        }

        [TestCase]
        public void TestRemove()
        {
            var d = _fixture.Create<string>();

            _presenter.Add(d);
            _presenter.Add(_fixture.Create<string>());
            _presenter.Remove(new TodoItem(0, d));

            Assert.That(_presenter.ViewModel.ItemsCount == 1);
        }

        [TestCase]
        public void MarkComplete()
        {
            var d = _fixture.Create<string>();
            _presenter.Add(d);
            _presenter.Add(d);

            _presenter.ToggleComplete(new TodoItem(0, d));

            Assert.That(_presenter.ViewModel.HasCompletedItems);
            Assert.That(_presenter.GetCompletedList().Count() == 1);
            Assert.That(_presenter.GetActiveList().Count() == 1);
        }

        [TestCase]
        public void MarkAllComplete()
        {
            const int Count = 10;
            for (var i = 0; i < 10; i++)
            {
                _presenter.Add(_fixture.Create<string>());
            }

            _presenter.ToggleAllComplete();

            Assert.That(_presenter.ViewModel.HasCompletedItems);
            Assert.That(_presenter.GetCompletedList().Count() == Count);
            Assert.That(!this._presenter.GetActiveList().Any());
        }

        [TestCase]
        public void TestClearCompleted()
        {
            const int Count = 10;
            for (var i = 0; i < 10; i++)
            {
                _presenter.Add(_fixture.Create<string>());
            }

            _presenter.ToggleAllComplete();

            Assert.That(_presenter.ViewModel.HasCompletedItems);
            Assert.That(_presenter.GetCompletedList().Count() == Count);
            Assert.That(!this._presenter.GetActiveList().Any());

            _presenter.ClearCompleted();

            Assert.That(!_presenter.ViewModel.HasCompletedItems);
            Assert.That(!this._presenter.GetCompletedList().Any());
        }

    }
}

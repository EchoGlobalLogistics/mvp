async = require("async")

require('./../web/config/beforeStart')

TodoListPresenter = require('./../presenter/todo-presenter').TodoListPresenter


describe("Todo Presenter Test", () ->


    presenter = null

    beforeEach(() ->
        persistorManager = require('./../data/dataUtils').persistorManager
        TodoPersistor = require('./../data/TodoPersistor')
        persistorManager.setPersistor(new TodoPersistor())
        presenter = new TodoListPresenter()
    )

    it("add", () ->
        presenter.addItem("add 1", () ->
            expect(presenter.viewModel().itemsCount).toBe(1)
        )
    )
    it("addDuplicate", () ->
        async.series([(cb) ->
            presenter.addItem("addDuplicate 1", cb)
        , (cb) ->
            presenter.addItem("addDuplicate 2", cb)
        ], (err, results) ->
            expect(presenter.viewModel().itemsCount).toBe(2)
        )
    )
    it("remove", () ->
        presenter.addItem("remove", (err, item) ->
            presenter.removeItem(item, () ->
                expect(presenter.viewModel().itemsCount).toBe(0)
            )
        )
    )
    it("markComplete", () ->
        async.series([(cb) ->
           presenter.addItem("markComplete 1", cb)
        , (cb) ->
           presenter.addItem("markComplete 2", cb)
        ], (err, results) ->
           presenter.setCompleted(results[0], true, () ->
               expect(presenter.viewModel().hasCompletedItems()).toBe(true)
               expect(presenter.viewModel().completedCount(true)).toBe(1)
               expect(presenter.viewModel().completedCount(false)).toBe(1)
           )
        )
    )
    it("markAllComplete", () ->
        items = ("markAllComplete #{i}" for i in [0 .. 10])
        add = presenter.addItem.bind(presenter)
        async.map(items, add, () ->
            presenter.setAllCompleted(true, () ->
                expect(presenter.viewModel().hasCompletedItems()).toBe(true)
                expect(presenter.viewModel().completedCount(true)).toBe(items.length)
                expect(presenter.viewModel().completedCount(false)).toBe(0)
            )
        )
    )
    it("clearCompleted", () ->
        items = ("clearCompleted #{i}" for i in [0 .. 10])
        add = presenter.addItem.bind(presenter)
        async.map(items, add, () ->
            async.series([(cb) ->
                presenter.setAllCompleted(true, cb)
            , (cb) ->
               presenter.clearCompleted(cb)
            ], (err, results) ->
                expect(presenter.viewModel().hasCompletedItems()).toBe(false)
                expect(presenter.viewModel().itemsCount).toBe(0)
            )
        )
    )


)

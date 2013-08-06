presenter = require('../../presenter/todo-presenter')
BaseController = require('./base')
todoListPresenter = new presenter.TodoListPresenter()

single = (res, item) ->
    res.json(item: todoListPresenter.viewModel().getItem(item.id), footer: todoListPresenter.viewModel().footer())

list = (res) ->
    res.render('todo/base.html', model: todoListPresenter.viewModel(), footer: todoListPresenter.viewModel().footer())

class TodoController extends BaseController
    index: (req, res, next) ->
        todoListPresenter.getAllList((err, item) ->
            return next(err) if err
            list(res)
        )

    create: (req, res, next) ->
        todoListPresenter.addItem(req.param('description'), (err, item) ->
            return next(err) if err
            single(res, item)
        )

    update: (req, res, next) ->
        todoListPresenter.updateItem(req.todoItem, (err, item) ->
            return next(err) if err
            single(res, item)
        )

    delete: (req, res, next) ->
        todoListPresenter.removeItem(req.todoItem, (err, item) ->
            return next(err) if err
            single(res, item)
        )

    setCompleted: (req, res, next) ->
        todoListPresenter.setCompleted(req.todoItem, req.todoItem.completed or false, (err, item) ->
            return next(err) if err
            single(res, item)
        )

    setAllCompleted: (req, res, next) ->
        todoListPresenter.setAllCompleted(req.param('completed') or false, (err, items) ->
            return next(err) if err
            res.redirect('/')
        )

    activeList: (req, res, next) ->
        todoListPresenter.getActiveList((err) ->
            return next(err) if err
            list(res)
        )

    completedList: (req, res, next) ->
        todoListPresenter.getCompletedList((err) ->
            return next(err) if err
            list(res)
        )

    clearCompleted: (req, res, next) ->
        todoListPresenter.clearCompleted((err) ->
            return next(err) if err
            res.redirect("/")
        )



module.exports = new TodoController()


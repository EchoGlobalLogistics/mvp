# Presenter contains presentation & biz logic
# View doesn't have reference to Model
# View passes calls to Presenter
# Presenter updates View
# Presenter manipulates Model
# Model fires events on Presenter
# MVVM assumes that changes in the ViewModel/Presenter will be reflected in the view by a robust data-binding engine
# Commands can be shared across Presenters
# Commands help gather data from the service layer
# Presenter composes ViewModel from the data returned by commands
# Behaviors can be implemented as mixins

_ = require('underscore')
mixOf = require('../core/module').mixOf

behaviors = require('./behaviors')
commands = require('./commands')
models = require('./models')


TodoListViewModel = require('./TodoListViewModel')

helper = (cb, cb2=->) ->
    return (err, item) ->
        cb2(err, item) unless err #normally cb would be used as a callback to cb2, but i am going to skip that step since cb2 is not async in our impl
        cb(err, item)

class TodoListPresenter extends mixOf(behaviors.todo.TodoListBehavior, behaviors.todo.TodoCompletionBehavior)

    constructor: () ->
        @todoList = new TodoListViewModel()  #this in memory store does not work. its created on every request (need to rewrite)

    fetch: (fn) => #helper for reloading the todolist prior to calling fn
        return (args...) ->
            command = new commands.todo.FetchAllTodoItems()
            command.execute((err, items=[]) =>
                @todoList.todoItems = items
                @todoList.state = models.TodoListState.all
                fn.apply(@, args)
            )

    addItem: (description, cb=->) ->
        command = new commands.todo.AddTodoCommand(description)
        command.execute(helper(cb, (err, item) =>
            @todoList.updateItem(item.id, item)
        ))

    updateItem: (todoItem, cb=->) ->
        command = new commands.todo.UpdateTodoCommand(todoItem)
        command.execute(helper(cb, (err, item) =>
            @todoList.updateItem(item.id, item)
        ))

    removeItem: (todoItem, cb=->) ->
        command = new commands.todo.RemoveTodoCommand(todoItem)
        command.execute(helper(cb, (err, item) =>
            @todoList.removeItem(item.id)
        ))

    setCompleted: (todoItem, isCompleted, cb=->) ->
        command = new commands.todo.SetCompletedTodoCommand(todoItem, isCompleted)
        command.execute(helper(cb, (err, item) =>
            @todoList.updateItem(item.id, item)
        ))

    setAllCompleted: @::fetch((isCompleted, cb=->) ->
        command = new commands.todo.SetCompletedAllCommand(@todoList.getAllItems(), isCompleted)
        command.execute(helper(cb, (err, items) =>
            @todoList.todoItems = items
        ))
    )

    getActiveList: @::fetch((cb=->) ->
        command = new commands.todo.FilterTodosByCompletion(@todoList.getAllItems(), false)
        command.execute(helper(cb, (err, items) =>
            @todoList.todoItems  = items
            @todoList.state = models.TodoListState.active
        ))
    )

    getCompletedList: @::fetch((cb=->) ->
        command = new commands.todo.FilterTodosByCompletion(@todoList.getAllItems(), true)
        command.execute(helper(cb, (err, items) =>
            @todoList.todoItems = items
            @todoList.state = models.TodoListState.completed
        ))
    )

    clearCompleted: (cb=->) ->
        command = new commands.todo.ClearTodosByCompletion(@todoList.getAllItems(), true)
        command.execute(helper(cb, (err, items) =>
            @todoList.todoItems = items
        ))

    getAllList: @::fetch((cb=->) ->
        cb(null, @todoList.getAllItems())
    )

    viewModel: ->
        @todoList

exports.TodoListPresenter = TodoListPresenter
commands = require('./index')
_ = require("underscore")

persistorManager = require('../../data/dataUtils').persistorManager
TodoItem = require('../models/todo-item')


class TodoCommand extends commands.Command
    constructor: (@persistor=persistorManager.getPersistor()) ->

class AddTodoCommand extends TodoCommand
    constructor: (@description) ->
        super()

    execute: (cb=->) ->
        item = new TodoItem(null, @description)
        @persistor.create(item, cb)

class UpdateTodoCommand extends TodoCommand
    constructor: (@todoItem, @cb=->) ->
        super()

    execute: (cb=->) ->
        @persistor.save(@todoItem, cb)

class RemoveTodoCommand extends TodoCommand
    constructor: (@todoItem) ->
        super()

    execute: (cb=->) ->
        @persistor.remove(@todoItem, cb)

class SetCompletedTodoCommand extends TodoCommand
    constructor: (@todoItem, @isCompleted) ->
        super()

    execute: (cb=->)->
        @todoItem.setCompleted(@isCompleted)
        @persistor.save(@todoItem, cb)

class SetCompletedAllCommand extends TodoCommand
    constructor: (@todoItems, @isCompleted) ->
        super()

    execute: (cb=->) ->
        for item in @todoItems
            item.setCompleted(@isCompleted)
        @persistor.saveAll(@todoItems, cb)

class FilterTodosByCompletion extends TodoCommand
    constructor: (@todoItems=[], @isCompleted=true) ->
        super()

    execute: (cb=->) ->
        cb(null, _.filter(@todoItems, (todoItem) =>
            todoItem.completed == @isCompleted
        ))

class ClearTodosByCompletion extends TodoCommand
    constructor: (@todoItems=[]) ->
        super()

    execute: (cb=->) ->
        ret = []
        for todoItem in @todoItems
            if todoItem.completed
                @persistor.remove(todoItem)
            else
                ret.push(todoItem)
        cb(null, ret)

class FetchAllTodoItems extends TodoCommand
    constructor: () ->
        super()

    execute: (cb) ->
        @persistor.fetch(cb)

exports.AddTodoCommand = AddTodoCommand
exports.RemoveTodoCommand = RemoveTodoCommand
exports.SetCompletedTodoCommand = SetCompletedTodoCommand
exports.UpdateTodoCommand = UpdateTodoCommand
exports.FetchAllTodoItems = FetchAllTodoItems
exports.SetCompletedAllCommand = SetCompletedAllCommand
exports.FilterTodosByCompletion = FilterTodosByCompletion
exports.ClearTodosByCompletion = ClearTodosByCompletion

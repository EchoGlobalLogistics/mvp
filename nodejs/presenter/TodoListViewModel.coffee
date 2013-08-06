_ = require('underscore')
models = require('./models')


class TodoListViewModel

    constructor: ->
        @items = {}
        @state = models.TodoListState.all

    @property 'todoItems',
        get: ->
            _.values(@items)
        set: (values) ->
            @items = {}
            for item in values
                @items[item.id] = item

    @property 'currentState',
        get: -> @state
        set: (value) -> @state = value

    @property 'itemsLabel',
        get: -> if @itemsCount > 1 or @itemsCount == 0 then "items" else "item"

    @property 'itemsCount',
        get: -> _.values(@items).length

    updateItem: (id, item) ->
        @items[id] = item

    getItem: (id) ->
        @items[id]

    removeItem: (id) ->
        delete @items[id]

    getAllItems: ->
        _.sortBy(_.values(@items), (item) -> item.id)

    hasCompletedItems: (isComplete=true) ->
        _.any(@items, (item) -> item.completed == isComplete)

    allItemsComplete: ->
        not @hasCompletedItems(false)

    completedCount: (isComplete=true)->
        _.reduce(_.values(@items), ((count, item) ->
            count + if item.completed is isComplete then 1 else 0
        ), 0)

    todoList: (items) ->
        if arguments.length == 1
            @items = items
        else
            @items

    footer: () ->
        activeTodoCount: @completedCount(false)
        completedTodos: @completedCount(true)
        itemLabel: @itemsLabel
        state:
            all: @state == models.TodoListState.all
            active: @state == models.TodoListState.active
            completed: @state == models.TodoListState.completed

module.exports = TodoListViewModel
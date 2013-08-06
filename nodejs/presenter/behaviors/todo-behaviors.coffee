exports.TodoListBehavior =
    extended: ->
        @include
            addItem: (description) ->
            removeItem: (todoItem) ->
            toggleCompleted: (todoItem) ->
            getAllItems: ->

exports.TodoCompletionBehavior =
    extended: ->
        @include
            toggleCompleted: (todoItem) ->
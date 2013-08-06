parseBoolean = (bool) ->
    bool is true or bool is 'true' or bool is 'on' or bool is 'yes' or bool is 1

class TodoItem
    constructor: (@id, @description, completed=false) ->
        @completed = parseBoolean(completed)

    setCompleted: (completed=true) ->
        @completed = parseBoolean(completed)

module.exports = TodoItem

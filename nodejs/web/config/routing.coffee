controllers = require('../controllers')
models = require('../../presenter/models')


exports.configure = (app) ->
    app.param('id', (req, res, next, id) ->
        req.todoItem = new models.TodoItem(parseInt(id, 10), req.body.description, req.body.completed)
        next()
    )

    app.get('/', controllers.todo.index)
    app.post('/create/', controllers.todo.create)
    app.put('/item/:id/', controllers.todo.update)
    app.delete('/item/:id/', controllers.todo.delete)
    app.put('/setCompleted/:id/', controllers.todo.setCompleted)
    app.post('/setCompleted/', controllers.todo.setAllCompleted)
    app.all('/clearCompleted/', controllers.todo.clearCompleted)
    app.all('/active/', controllers.todo.activeList)
    app.all('/completed/', controllers.todo.completedList)

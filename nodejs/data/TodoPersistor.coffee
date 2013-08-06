_ = require('underscore')

utils = require('./dataUtils')
mixOf = require('../core/module').mixOf

id = 0

class TodoPersitor extends mixOf(utils.Persistor)

    constructor: (@store={}) ->

    create: (obj, cb=->) ->
        obj.id = id++
        @store[obj.id] = obj
        cb(null, obj)

    save: (obj, cb=->) ->
        @store[obj.id] = obj
        cb(null, obj)

    remove: (obj, cb=->) ->
        delete @store[obj.id]
        cb(null, obj)

    fetch: (cb=->) ->
        cb(null, _.values(@store))

    saveAll: (list, cb=->) ->
        _.each(list, (item) =>
            @save(item)
        )
        cb(null, list)


module.exports = TodoPersitor
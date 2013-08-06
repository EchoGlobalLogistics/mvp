Persistor =
    create: (obj, cb) ->
    save: (obj, cb) ->
    remove: (obj, cb) ->
    fetchAll: (cb) ->
    saveAll: (cb) ->


class PersistorManager
    constructor: (@persistor) ->

    setPersistor: (persistor) ->
        @persistor = persistor

    getPersistor: () ->
        @persistor

exports.Persistor = Persistor
exports.persistorManager = new PersistorManager() #TODO: i recommend that we create a more generic IOC container or better yet see if one already exists that we can use.
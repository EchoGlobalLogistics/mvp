
#monkey patch native objects

#make ES5 properties easier to use in CS
Function::property ?= (prop, desc) ->
    Object.defineProperty @prototype, prop, desc

'''
@property 'foo',
    get: -> _foo
    set: (value) -> _foo = value
'''


persistorManager = require('./../../data/dataUtils').persistorManager

TodoPersistor = require('./../../data/TodoPersistor')
persistorManager.setPersistor(new TodoPersistor())
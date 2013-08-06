class BaseController
    constructor: () ->
        for name, func of this
            if name not in ["constructor", "action"] and name.indexOf("__") isnt 0
                if this.__before__
                    this[name] = this.__wrap__(name, this.__before__, this[name])
                if this.__after__
                    this[name] = this.__wrap__(name, this[name], this.__after__)

    __wrap__: (name, func_a, func_b) ->
        return (req, res, next) ->
            func_a(req, res, next)
            func_b(req, res, next)

module.exports = BaseController
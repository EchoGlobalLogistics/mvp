nunjucks = require('nunjucks')
path = require('path')

exports.configure = (app) ->
    env = new nunjucks.Environment(new nunjucks.FileSystemLoader([path.join(__dirname, '../public/templates'), path.join(__dirname, '../views')]))
    env.express(app)

    exports.env = env


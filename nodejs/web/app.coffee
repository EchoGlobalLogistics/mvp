require('coffee-script')
express = require('express')
http = require('http')
path = require('path')

require('./config/beforeStart')

middleware = require('./config/middleware')
routing = require('./config/routing')
templating = require('./config/templating')


app = express()

middleware.configure(app)
routing.configure(app)
templating.configure(app)

http.createServer(app).listen(app.get('port'), ->
    console.log 'Express server listening on port ' + app.get('port')
)

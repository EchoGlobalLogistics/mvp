express = require('express')
flash = require('connect-flash')
path = require('path')


exports.configure = (app) ->
    # all environments
    app.set('port', process.env.PORT or 3000)
    app.use(express.favicon())
    app.use(express.logger('dev'))
    app.use(express.bodyParser())
    app.use(express.methodOverride())
    app.use(express.cookieParser('catman cat'));
    app.use(express.session({ secret: 'keyboard cat', cookie: { maxAge: 600000 }}))
    app.use(require('less-middleware')(src: path.join(__dirname, '../public')))
    app.use(express.static(path.join(__dirname, '../public')))
    app.use(flash());

    app.use((req, res, next) ->
        res.locals.flash = () -> return req.flash() || {}
        next()
    )

    # monkey patch express to properly handle json flashes and redirects
    app.use((req, res, next) ->
        shadow = {json: res.json, redirect: res.redirect}

        getJsonResponse = (content=null) ->
            flashes = req.flash() || {success: [], error:[]}
            {content: content, flash: flashes}


        res.json = (content=null) -> #make json respond in the format we expect and preserve flashes
            body = getJsonResponse(content)
            shadow.json.apply(res, [body])

        res.redirect = (url) -> #make redirect behave properly when we expect a json response
            if req.xhr
                body = getJsonResponse()
                body.redirect = url
                shadow.json.apply(res, [body])
            else
                shadow.redirect.apply(res, [url])

        next()
    )

    app.use(app.router)
#    app.use('/static', require('less-middleware')({
#        src: path.join(__dirname, '../public'),
#        dest: path.join(__dirname, '../compiled')
#    }))
    app.use('/static', require('connect-coffee-script')({
        src: path.join(__dirname, '../public'),
        dest: path.join(__dirname, '../compiled')
    }));

    app.use('/static', express.static(path.join(__dirname, '../public')))
    app.use('/static', express.static(path.join(__dirname, '../compiled')))

    # development only
    if app.get('env') is 'development'
        app.use(express.errorHandler())

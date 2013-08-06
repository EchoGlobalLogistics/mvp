
if(!nunjucks.env)
  # If not precompiled, create an environment with an HTTP  loader
  nunjucks.env = new nunjucks.Environment(new nunjucks.HttpLoader('/static/templates'))

X.render = (tpl, ctx={}) -> #render a nunjucks template by name. ctx is the object of params to pass to it
  tpl = nunjucks.env.getTemplate(tpl);
  return tpl.render(ctx)

X.macro = (name, ctx={}, tpl='macros.html') -> #render a nunjucks macro by name.
    return nunjucks.env.getTemplate(tpl).getExported()[name](ctx)


$(() ->
  $doc = $(document)
  $doc.ajaxSuccess((event, xhr, settings) ->
    try
      if(xhr.getResponseHeader("content-type") || '').toLowerCase().indexOf('json') > -1
        json = JSON.parse(xhr.responseText)
        if(not _.isEmpty(json.flash))
          evt = $.Event("flash", {flash: json.flash})
          $doc.trigger(evt)
          if (!evt.isDefaultPrevented()) #allow us to change or delete flashes before display
            X.flash(evt.flash) if evt.flash

        if (json.redirect)
          evt = $.Event("redirect", {redirect: json.redirect})
          $doc.trigger(evt);
          if (!evt.isDefaultPrevented())  #allow us to abort redirect or override the location
            window.location = evt.redirect
            event.stopImmediatePropagation()
            event.stopPropagation()

    catch e

  )
  return
)
X.flash = (flashes) ->
  $cont = $("body div.flash-container")
  deduped = {}
  _.each(flashes, (messages, type) ->
    deduped[type] = []
    _.each(messages, (text) ->
      $existing = $cont.find(".alert-#{type}:visible .msg:contains('#{text}')")
      if $existing.length
        $existing.next().text((i, str) ->
          return 'x'+ if str then (parseInt(str[1..], 10) + 1) else 2
        )
      else
        deduped[type].push(text)
    )
    if deduped[type].length == 0
      delete deduped[type]
  )

  if not _.isEmpty(deduped)
    $cont.append(X.macro('flash', deduped));
    Behavior2.contentChanged('flash');







Behavior2.Class('flash', 'body div.flash-container .alert', ($ctx, that) ->
  setTimeout(() ->
    $ctx.fadeOut('slow')
  , 4200)
)
Behavior2.Class('flashContainer', 'body div.flash-container', ($ctx, that) ->
  $ctx.scrollToFixed({
    marginTop: 40
  })
)
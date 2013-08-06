Behavior2.Class('app', 'div.todoapp', {
  keypress: {
    'input#new-todo' : 'create'
    'input.edit' : 'edit'
  }
  click: {
    'input.toggle' : 'toggle'
    'button.destroy': 'delete'
    'input#toggle-all': 'submit'
  },
  dblclick: {
    '.todo-text': 'showEditor'
  },
  blur: {
    'input.edit' : 'hideEditor'
  }
}, ($ctx, that) ->

  $list = $ctx.find('#todo-list');
  $toggle = $ctx.find('input#toggle-all')
  $footer = $ctx.find('#footer')
  $activeEditor = $([])

  ajax = (e, method, cb) ->
    $form = $(e.currentTarget).closest('form');

    itemId = $form.data('id');
    $.ajax({
      url: "/item/#{itemId}/",
      dataType: 'json',
      method: method,
      data: $form.serializeArray()
    }).done((data) ->
      cb(data, itemId, $form)
    )

  renderItem = (data) ->
    $footer.html(X.macro('footer', data.content.footer, 'todo.html'))
    return X.macro('todoItem', data.content.item, 'todo.html')

  plainSave = (e, cb) ->
    e.preventDefault()
    ajax(e, 'put', (data, itemId, $form) ->
        $form.replaceWith(renderItem(data))
        cb()
    )

  renderUI = () ->
    $checks = $ctx.find('input.toggle')
    totalItems = $checks.length
    doneItems = $checks.filter(':checked').length
    $toggle.prop('checked', totalItems == doneItems)

  updateUI = (fn) ->
    return (e) ->
      fn(e, renderUI)


  that.save = updateUI(plainSave)

  that.toggle = updateUI((e, cb) ->
      e.preventDefault()
      $target = $(e.currentTarget)
      $form = $target.closest('form')
      itemId = $form.data('id')
      $.ajax({
          url: "/setCompleted/#{itemId}/",
          dataType: 'json',
          method: 'put',
          data: $form.serializeArray()
      }).done((data) ->
          $form.replaceWith(renderItem(data))
          cb()
      )
  )

  that.create = updateUI((e, cb) ->
    if e.keyCode == 13
      $target = $(e.currentTarget)
      val = $target.val()
      if $.trim(val) == ''
        X.flash({'error': ['You must enter a description']})
      else
        $.post("/create/", {description: val}, (data) ->
            $list.prepend(renderItem(data))
            $target.val('')
            cb()
        )
  )

  that.delete = updateUI((e, cb) ->
    e.preventDefault()
    ajax(e, 'delete', (data, itemId, $form) ->
        $form.remove()
        cb()
    )
  )
  that.submit = (e) ->
    e.preventDefault()
    $target = $(e.currentTarget)
    $form = $target.closest('form')
    $form.submit()

  that.showEditor = (e) ->
    $target = $(e.currentTarget)
    $li = $target.closest('li')
    $activeEditor.removeClass('editing')
    $activeEditor = $li
    $li.addClass('editing')
    $li.find('.todo-input').focus().val($target.text())

  that.hideEditor = (e) ->
    $(e.currentTarget).closest('li').removeClass("editing")

  that.edit = (e) ->
    if e.keyCode == 13
      e.preventDefault()
      that.save(e)
      that.hideEditor(e)


  return;
)
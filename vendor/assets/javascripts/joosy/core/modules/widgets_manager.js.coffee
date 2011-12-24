Joosy.Modules.WidgetsManager =
  registerWidget: (container, widget) ->
    @__activeWidgets ||= []

    if Joosy.Module.has_ancestor(widget, Joosy.Widget)
      widget = new widget()

    @__activeWidgets.push widget.__load(@, container)
    return widget

  unregisterWidget: (widget) ->
    widget.__unload()
    delete @__activeWidgets[@__activeWidgets.indexOf(widget)]

  __setupWidgets: ->
    widgets = Object.extended(@widgets || {})

    x = @__proto__
    widgets.merge(x.widgets, false) while x = x.__proto__

    return unless widgets

    widgets.each (selector, widget) =>
      parent = @

      if selector == '$container'
        selector = @container
      else
        if r = selector.match(/\$([A-z]+)/)
          selector = @elements[r[1]]
        selector = @$(selector)

      Joosy.Modules.Log.log "Widget registered at '#{selector.selector}'. Elements: #{selector.length}"

      selector.each (i) ->
        if Joosy.Module.has_ancestor(widget, Joosy.Widget)
          w = new widget(parent)
        else
          w = widget.apply(parent, [i])

        parent.registerWidget $(this), w

  __unloadWidgets: ->
    if @__activeWidgets
      widget?.__unload() for widget in @__activeWidgets
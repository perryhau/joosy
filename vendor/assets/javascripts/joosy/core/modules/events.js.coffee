Joosy.Modules.Events =
  wait: (events, callback) ->
    events = events.split(' ')
    @__eventWaiters ||= []

    @__eventWaiters.push [events, callback]

  trigger: (event) ->
    return unless @__eventWaiters

    @__eventWaiters.each (entry, i) =>
      index = entry[0].indexOf(event)
      delete entry[0][index] if index >= 0

      if entry[0].compact().length == 0
        delete @__eventWaiters[i] and @__eventWaiters = @__eventWaiters.compact()
        entry[1].call()